package org.example.service;

import com.azure.resourcemanager.costmanagement.CostManagementManager;
import com.azure.resourcemanager.costmanagement.models.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.MonthlyCost;
import org.example.entity.Vm;
import org.example.repository.MonthlyCostRepository;
import org.example.repository.VmRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@Slf4j
@RequiredArgsConstructor
public class MonthlyCostSyncService {

    private final CostManagementManager costManagementManager;
    private final MonthlyCostRepository monthlyCostRepository;
    private final VmRepository vmRepository;

    @Value("${azure.subscription-id}")
    private String subscriptionId;

    private Map<String, Long> vmNameToIdCache;
    private Map<String, String> vmUuidToNameCache;
    private Set<String> vmNamesLowerCase;

    private static final Pattern UUID_PATTERN = Pattern.compile("[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}");

    @Transactional
    public String syncMonthlyCostsFromAzure(int year, int month) {
        long startTime = System.currentTimeMillis();
        log.info("========== STARTING SYNC for {}-{} ==========", year, month);

        try {
            loadVmCache();
            log.info("Loaded {} VMs into cache: {}", vmNameToIdCache.size(), vmNamesLowerCase);

            LocalDate firstDay = LocalDate.of(year, month, 1);
            LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth());

            // Delete existing data
            int deletedCount = monthlyCostRepository.deleteByMonthAndYear(month, year);
            log.info("Deleted {} existing records for {}-{}", deletedCount, year, month);

            // Fetch and process
            List<MonthlyCost> costsToSave = fetchAndProcessAzureCosts(firstDay, lastDay, month, year);

            if (costsToSave.isEmpty()) {
                log.warn("No cost data found for {}-{}", year, month);
                return String.format("No cost data found for month %d/%d", month, year);
            }

            // Bulk save
            List<MonthlyCost> savedCosts = monthlyCostRepository.saveAll(costsToSave);

            long duration = System.currentTimeMillis() - startTime;
            long vmAssociated = savedCosts.stream().filter(c -> c.getVmId() != null).count();
            long shared = savedCosts.stream().filter(c -> c.getVmId() == null).count();

            log.info("========== SYNC COMPLETED for {}-{} in {} ms ==========", year, month, duration);
            log.info("Saved {} records ({} VM-associated, {} shared)", savedCosts.size(), vmAssociated, shared);

            return String.format("Successfully saved %d records for %d/%d (%d VM-associated, %d shared, Duration: %d ms)",
                    savedCosts.size(), month, year, vmAssociated, shared, duration);

        } catch (Exception e) {
            log.error("Sync failed for {}-{}: {}", year, month, e.getMessage(), e);
            throw new RuntimeException("Cost sync failed: " + e.getMessage(), e);
        }
    }

    private void loadVmCache() {
        List<Vm> allVms = vmRepository.findAll();
        vmNameToIdCache = new HashMap<>();
        vmUuidToNameCache = new HashMap<>();
        vmNamesLowerCase = new HashSet<>();

        for (Vm vm : allVms) {
            String vmName = vm.getName().toLowerCase();
            vmNameToIdCache.put(vmName, vm.getId());
            vmNamesLowerCase.add(vmName);

            // Also store with underscores for pattern matching (convert hyphens to underscores)
            vmNameToIdCache.put(vmName.replace("-", "_"), vm.getId());

            // Extract UUID from Azure VM ID for backup mapping
            if (vm.getAzureVmId() != null && !vm.getAzureVmId().isEmpty()) {
                Matcher uuidMatcher = UUID_PATTERN.matcher(vm.getAzureVmId().toLowerCase());
                if (uuidMatcher.find()) {
                    vmUuidToNameCache.put(uuidMatcher.group(), vmName);
                }
            }
        }
    }

    private List<MonthlyCost> fetchAndProcessAzureCosts(LocalDate startDate, LocalDate endDate, int month, int year) {
        List<MonthlyCost> costs = new ArrayList<>();

        String scope = String.format("/subscriptions/%s", subscriptionId);

        OffsetDateTime startDateTime = startDate.atStartOfDay().atOffset(ZoneOffset.UTC);
        OffsetDateTime endDateTime = endDate.atTime(23, 59, 59).atOffset(ZoneOffset.UTC);

        QueryDefinition queryDefinition = new QueryDefinition()
                .withType(ExportType.ACTUAL_COST)
                .withTimeframe(TimeframeType.CUSTOM)
                .withTimePeriod(new QueryTimePeriod()
                        .withFrom(startDateTime)
                        .withTo(endDateTime))
                .withDataset(new QueryDataset()
                        .withAggregation(Map.of(
                                "totalCost", new QueryAggregation()
                                        .withName("Cost")
                                        .withFunction(FunctionType.SUM)
                        ))
                        .withGrouping(List.of(
                                new QueryGrouping()
                                        .withType(QueryColumnType.DIMENSION)
                                        .withName("ResourceId"),
                                new QueryGrouping()
                                        .withType(QueryColumnType.DIMENSION)
                                        .withName("ServiceName"),
                                new QueryGrouping()
                                        .withType(QueryColumnType.DIMENSION)
                                        .withName("Meter"),
                                new QueryGrouping()
                                        .withType(QueryColumnType.DIMENSION)
                                        .withName("PricingModel"),
                                new QueryGrouping()
                                        .withType(QueryColumnType.DIMENSION)
                                        .withName("BenefitName")
                        )));

        try {
            QueryResult result = costManagementManager.queries().usage(scope, queryDefinition);

            if (result != null && result.rows() != null) {
                Map<String, Integer> columnIndex = buildColumnIndexMap(result);

                Integer resourceIdIdx = columnIndex.get("ResourceId");
                Integer costIdx = columnIndex.get("Cost");
                Integer serviceNameIdx = columnIndex.get("ServiceName");
                Integer meterIdx = columnIndex.get("Meter");
                Integer pricingModelIdx = columnIndex.get("PricingModel");
                Integer benefitNameIdx = columnIndex.get("BenefitName");

                int processedCount = 0;
                int vmAssociatedCount = 0;

                for (List<Object> row : result.rows()) {
                    MonthlyCost monthlyCost = processRow(row, resourceIdIdx, costIdx, serviceNameIdx,
                            meterIdx, pricingModelIdx, benefitNameIdx,
                            month, year);
                    if (monthlyCost != null) {
                        costs.add(monthlyCost);
                        processedCount++;
                        if (monthlyCost.getVmId() != null) {
                            vmAssociatedCount++;
                        }
                    }
                }

                log.info("Processed {} rows: {} VM-associated, {} shared", processedCount, vmAssociatedCount, processedCount - vmAssociatedCount);
            }

        } catch (Exception e) {
            log.error("Azure fetch error: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to fetch costs from Azure", e);
        }

        return costs;
    }

    private Map<String, Integer> buildColumnIndexMap(QueryResult result) {
        Map<String, Integer> columnIndex = new HashMap<>();
        if (result.columns() != null) {
            for (int i = 0; i < result.columns().size(); i++) {
                columnIndex.put(result.columns().get(i).name(), i);
            }
        }
        return columnIndex;
    }

    private MonthlyCost processRow(List<Object> row, Integer resourceIdIdx, Integer costIdx,
                                   Integer serviceNameIdx, Integer meterIdx, Integer pricingModelIdx,
                                   Integer benefitNameIdx, int month, int year) {
        try {
            if (row.size() < 4) return null;

            BigDecimal cost = parseCostValue(row.get(costIdx));
            if (cost.compareTo(BigDecimal.ZERO) == 0) return null;

            String resourceId = getValueAsString(row, resourceIdIdx);
            String serviceName = getValueAsString(row, serviceNameIdx);
            String meterName = getValueAsString(row, meterIdx);
            String pricingModel = getValueAsString(row, pricingModelIdx);
            String benefitName = getValueAsString(row, benefitNameIdx);

            // Build display meter name
            String displayMeterName = buildDisplayMeterName(meterName, benefitName, pricingModel);

            // CRITICAL: Extract VM ID from resourceId using ALL patterns
            Long vmId = extractVmIdFromResourceId(resourceId, serviceName, meterName);

            // Determine resource category
            String resourceCategory = getResourceCategory(resourceId, serviceName);

            return MonthlyCost.builder()
                    .month(month)
                    .year(year)
                    .meterName(displayMeterName)
                    .serviceName(serviceName != null ? serviceName : "Unknown")
                    .cost(cost.setScale(15, RoundingMode.HALF_UP))
                    .vmId(vmId)
                    .isShared(vmId == null)
                    .resourceCategory(resourceCategory)
                    .currency("USD")
                    .syncedAt(LocalDateTime.now())
                    .build();

        } catch (Exception e) {
            log.warn("Error processing row: {}", e.getMessage());
            return null;
        }
    }

    /**
     * MAIN EXTRACTION METHOD - Uses ALL possible patterns to find VM name
     */
    private Long extractVmIdFromResourceId(String resourceId, String serviceName, String meterName) {
        if (resourceId == null || resourceId.isEmpty()) {
            // For reservations without resourceId
            if ("Reservation".equals(serviceName) || meterName != null && meterName.contains("[RESERVATION]")) {
                return null; // Reservations are shared
            }
            return null;
        }

        String lowerResourceId = resourceId.toLowerCase();
        String extractedVmName = null;

        // ========== PATTERN 1: Direct Virtual Machine ==========
        // /subscriptions/.../virtualMachines/ltrms-db
        // /subscriptions/.../virtualMachines/pap-serbia
        Pattern vmDirectPattern = Pattern.compile("/virtual[mM]achines/([^/]+)");
        Matcher vmDirectMatcher = vmDirectPattern.matcher(resourceId);
        if (vmDirectMatcher.find()) {
            extractedVmName = vmDirectMatcher.group(1);
            log.debug("Pattern 1 (Direct VM): Found '{}'", extractedVmName);
        }

        // ========== PATTERN 2: Disks with _osdisk_ ==========
        // /disks/ltrms-db_osdisk_1_xxx
        if (extractedVmName == null) {
            Pattern diskPattern1 = Pattern.compile("/disks/([^/]+)_osdisk_");
            Matcher diskMatcher1 = diskPattern1.matcher(lowerResourceId);
            if (diskMatcher1.find()) {
                extractedVmName = diskMatcher1.group(1);
                log.debug("Pattern 2a (Disk _osdisk_): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 3: Disks with _os_disk ==========
        // /disks/pap_os_disk
        if (extractedVmName == null) {
            Pattern diskPattern2 = Pattern.compile("/disks/([^/]+)_os_disk");
            Matcher diskMatcher2 = diskPattern2.matcher(lowerResourceId);
            if (diskMatcher2.find()) {
                extractedVmName = diskMatcher2.group(1);
                log.debug("Pattern 2b (Disk _os_disk): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 4: Disks with _osdisk (no underscore after) ==========
        // /disks/pap_osdisk
        if (extractedVmName == null) {
            Pattern diskPattern3 = Pattern.compile("/disks/([^/]+)_osdisk($|_)");
            Matcher diskMatcher3 = diskPattern3.matcher(lowerResourceId);
            if (diskMatcher3.find()) {
                extractedVmName = diskMatcher3.group(1);
                log.debug("Pattern 2c (Disk _osdisk): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 5: Disks with _datadisk_ ==========
        if (extractedVmName == null) {
            Pattern diskPattern4 = Pattern.compile("/disks/([^/]+)_datadisk_");
            Matcher diskMatcher4 = diskPattern4.matcher(lowerResourceId);
            if (diskMatcher4.find()) {
                extractedVmName = diskMatcher4.group(1);
                log.debug("Pattern 2d (Disk _datadisk_): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 6: Disks with _disk_ ==========
        if (extractedVmName == null) {
            Pattern diskPattern5 = Pattern.compile("/disks/([^/]+)_disk_");
            Matcher diskMatcher5 = diskPattern5.matcher(lowerResourceId);
            if (diskMatcher5.find()) {
                extractedVmName = diskMatcher5.group(1);
                log.debug("Pattern 2e (Disk _disk_): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 7: Snapshots with _snapshot_ ==========
        // /snapshots/cip_snapshot_22022025
        if (extractedVmName == null) {
            Pattern snapshotPattern1 = Pattern.compile("/snapshots/([^/]+)_snapshot_");
            Matcher snapshotMatcher1 = snapshotPattern1.matcher(lowerResourceId);
            if (snapshotMatcher1.find()) {
                extractedVmName = snapshotMatcher1.group(1);
                log.debug("Pattern 3a (Snapshot _snapshot_): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 8: Snapshots with _full_snapshot_ (FIXED - stops at _full_snapshot) ==========
        // /snapshots/ltrms-externe_full_snapshot_06-02-2025
        if (extractedVmName == null) {
            Pattern snapshotPattern2 = Pattern.compile("/snapshots/([^/]+?)_full_snapshot_");
            Matcher snapshotMatcher2 = snapshotPattern2.matcher(lowerResourceId);
            if (snapshotMatcher2.find()) {
                extractedVmName = snapshotMatcher2.group(1);
                log.debug("Pattern 3b (Snapshot _full_snapshot_): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 9: Snapshots with -snapshot ==========
        // /snapshots/npp-snapshot
        if (extractedVmName == null) {
            Pattern snapshotPattern3 = Pattern.compile("/snapshots/([^/]+)-snapshot");
            Matcher snapshotMatcher3 = snapshotPattern3.matcher(lowerResourceId);
            if (snapshotMatcher3.find()) {
                extractedVmName = snapshotMatcher3.group(1);
                log.debug("Pattern 3c (Snapshot -snapshot): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 10: Azure Backup Snapshots with UUID ==========
        // /snapshots/azurebackup_46404923-8921-48d2-a434-6f470b58f89d_2026-01-02...
        if (extractedVmName == null && lowerResourceId.contains("azurebackup_")) {
            Matcher uuidMatcher = UUID_PATTERN.matcher(lowerResourceId);
            if (uuidMatcher.find()) {
                String uuid = uuidMatcher.group();
                String vmName = vmUuidToNameCache.get(uuid);
                if (vmName != null) {
                    extractedVmName = vmName;
                    log.debug("Pattern 4 (Backup UUID {}): Found VM '{}'", uuid, extractedVmName);
                }
            }
        }

        // ========== PATTERN 11: Public IPs with -ip ==========
        // /publicipaddresses/ltrms-externe-ip
        if (extractedVmName == null) {
            Pattern ipPattern = Pattern.compile("/public[iI][pP]Addresses/([^/]+)-ip");
            Matcher ipMatcher = ipPattern.matcher(lowerResourceId);
            if (ipMatcher.find()) {
                extractedVmName = ipMatcher.group(1);
                log.debug("Pattern 5 (Public IP): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 12: Log Analytics with -loganalytics ==========
        // /workspaces/pap-loganalytics
        if (extractedVmName == null) {
            Pattern laPattern = Pattern.compile("/workspaces/([^/]+)-loganalytics");
            Matcher laMatcher = laPattern.matcher(lowerResourceId);
            if (laMatcher.find()) {
                extractedVmName = laMatcher.group(1);
                log.debug("Pattern 6 (Log Analytics): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 13: Network Security Groups with nsg-leoni-xxx ==========
        // /networksecuritygroups/nsg-leoni-pap
        if (extractedVmName == null && lowerResourceId.contains("/networksecuritygroups/")) {
            Pattern nsgPattern = Pattern.compile("/networksecuritygroups/nsg-leoni-([^/]+)");
            Matcher nsgMatcher = nsgPattern.matcher(lowerResourceId);
            if (nsgMatcher.find()) {
                String nsgName = nsgMatcher.group(1);
                // Skip 'prod' as it's shared
                if (!"prod".equals(nsgName)) {
                    extractedVmName = nsgName;
                    log.debug("Pattern 7 (NSG): Found '{}'", extractedVmName);
                }
            }
        }

        // ========== PATTERN 14: Network Interfaces with -nic ==========
        // /networkInterfaces/ltrms-db-nic-001
        if (extractedVmName == null) {
            Pattern nicPattern = Pattern.compile("/network[iI]nterfaces/([^/]+)-nic");
            Matcher nicMatcher = nicPattern.matcher(lowerResourceId);
            if (nicMatcher.find()) {
                extractedVmName = nicMatcher.group(1);
                log.debug("Pattern 8 (NIC): Found '{}'", extractedVmName);
            }
        }

        // ========== PATTERN 15: Handle hyphen vs underscore (pap_serbia -> pap-serbia) ==========
        // Convert underscores to hyphens for lookup
        if (extractedVmName != null && extractedVmName.contains("_")) {
            String withHyphens = extractedVmName.replace("_", "-");
            if (vmNameToIdCache.containsKey(withHyphens.toLowerCase())) {
                extractedVmName = withHyphens;
                log.debug("Pattern 9 (Hyphen conversion): Converted '{}' to '{}'",
                        extractedVmName.replace("-", "_"), extractedVmName);
            }
        }


        if (extractedVmName == null) {
            for (String vmName : vmNamesLowerCase) {
                if (lowerResourceId.contains(vmName)) {
                    extractedVmName = vmName;
                    log.debug("Pattern 10 (Substring match): Found '{}' in resourceId", extractedVmName);
                    break;
                }
            }
        }


        if ("ltrms".equals(extractedVmName)) {
            log.debug("Pattern 11 (Shared Log Analytics): 'ltrms-loganalytics' is shared, not assigning to VM");
            return null;
        }

        if (extractedVmName != null) {
            Long vmId = vmNameToIdCache.get(extractedVmName.toLowerCase());
            if (vmId != null) {
                log.debug("Successfully mapped resource to VM: {} (ID: {})", extractedVmName, vmId);
                return vmId;
            } else {
                log.debug("Extracted VM name '{}' not found in database - marking as shared", extractedVmName);
            }
        }

        return null;
    }

    private String getResourceCategory(String resourceId, String serviceName) {
        if (resourceId == null) {
            if ("Virtual Machines".equals(serviceName)) return "VM_COMPUTE";
            return "SHARED";
        }

        String lower = resourceId.toLowerCase();

        if (lower.contains("/virtualmachines/")) return "VM";
        if (lower.contains("/disks/")) return "DISK";
        if (lower.contains("/snapshots/")) return "SNAPSHOT";
        if (lower.contains("/networkinterfaces/")) return "NETWORK";
        if (lower.contains("/publicipaddresses/")) return "PUBLIC_IP";
        if (lower.contains("/storageaccounts/")) return "STORAGE";
        if (lower.contains("/workspaces/")) return "LOG_ANALYTICS";
        if (lower.contains("/backupvaults/")) return "BACKUP";
        if (lower.contains("/networksecuritygroups/")) return "NSG";
        if (lower.contains("/metricalerts/")) return "ALERT";
        if (lower.contains("/providers/microsoft.capacity/")) return "RESERVATION";

        if ("Virtual Machines".equals(serviceName)) return "VM_COMPUTE";
        if ("Bandwidth".equals(serviceName)) return "NETWORK_BANDWIDTH";

        return "OTHER";
    }

    private String getValueAsString(List<Object> row, Integer index) {
        if (index == null || index >= row.size()) return null;
        Object value = row.get(index);
        return value != null ? String.valueOf(value) : null;
    }

    private String buildDisplayMeterName(String meterName, String benefitName, String pricingModel) {
        String result = meterName != null ? meterName : "Unknown";

        if (benefitName != null && !benefitName.isEmpty() && !"Reservation".equals(pricingModel)) {
            result = result + " [" + benefitName + "]";
        }
        if ("Reservation".equals(pricingModel)) {
            result = "[RESERVATION] " + result;
        }

        return result;
    }

    private BigDecimal parseCostValue(Object costObject) {
        if (costObject == null) return BigDecimal.ZERO;
        try {
            if (costObject instanceof BigDecimal bd) return bd;
            if (costObject instanceof Number n) return BigDecimal.valueOf(n.doubleValue());
            String s = costObject.toString().trim().replaceAll("[^\\d.\\-]", "");
            return (s.isEmpty() || s.equals("-")) ? BigDecimal.ZERO : new BigDecimal(s);
        } catch (NumberFormatException e) {
            log.warn("Cannot parse cost '{}', using ZERO", costObject);
            return BigDecimal.ZERO;
        }
    }
}