package org.example.service;

import com.azure.resourcemanager.costmanagement.CostManagementManager;
import com.azure.resourcemanager.costmanagement.models.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.RawCostRecordDto;
import org.example.entity.*;
import org.example.enums.CostType;
import org.example.repository.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AzureCostService {

    private final CostManagementManager costManager;
    private final VmRepository vmRepository;
    private final CostRecordRepository costRecordRepository;

    @Value("${azure.subscription-id}")
    private String subscriptionId;

    // Patterns for extracting VM names
    private static final Pattern VM_PATTERN = Pattern.compile("virtualmachines/([^/]+)", Pattern.CASE_INSENSITIVE);
    private static final Pattern DISK_PATTERN = Pattern.compile("disks/([^_]+)(?:_osdisk|_disk)?", Pattern.CASE_INSENSITIVE);
    private static final Pattern SNAPSHOT_PATTERN = Pattern.compile("snapshots/([^/]+)", Pattern.CASE_INSENSITIVE);
    private static final Pattern PUBLIC_IP_PATTERN = Pattern.compile("publicipaddresses/([^/]+)", Pattern.CASE_INSENSITIVE);
    private static final Pattern LOG_ANALYTICS_PATTERN = Pattern.compile("workspaces/([^/]+)", Pattern.CASE_INSENSITIVE);

    // Pattern to extract VM UUID from backup snapshot names (like azurebackup_46404923-8921-48d2-a434-6f470b58f89d_...)
    private static final Pattern BACKUP_VM_UUID_PATTERN = Pattern.compile("azurebackup_([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})", Pattern.CASE_INSENSITIVE);

    public List<RawCostRecordDto> getAllRawCostsForDate(LocalDate date) {
        String scope = "/subscriptions/" + subscriptionId;
        List<RawCostRecordDto> rawCosts = new ArrayList<>();

        log.info("Fetching ALL raw costs for date: {}", date);

        try {
            QueryDefinition query = new QueryDefinition()
                    .withType(ExportType.ACTUAL_COST)
                    .withTimeframe(TimeframeType.CUSTOM)
                    .withTimePeriod(new QueryTimePeriod()
                            .withFrom(date.atStartOfDay().atOffset(ZoneOffset.UTC))
                            .withTo(date.atTime(23, 59, 59).atOffset(ZoneOffset.UTC)))
                    .withDataset(new QueryDataset()
                            .withGranularity(GranularityType.DAILY)
                            .withAggregation(new HashMap<String, QueryAggregation>() {{
                                put("totalCost", new QueryAggregation()
                                        .withName("Cost")
                                        .withFunction(FunctionType.SUM));
                            }})
                            .withGrouping(Arrays.asList(
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ResourceId"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("MeterCategory"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("MeterSubCategory"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("Meter"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ResourceLocation"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("PricingModel"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("BenefitName"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ServiceName"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ServiceTier")
                            )));

            QueryResult result = costManager.queries().usage(scope, query);

            if (result == null || result.rows() == null) {
                log.warn("No data returned from Azure for date: {}", date);
                return rawCosts;
            }

            Map<String, Integer> columnIndex = new HashMap<>();
            if (result.columns() != null) {
                for (int i = 0; i < result.columns().size(); i++) {
                    columnIndex.put(result.columns().get(i).name(), i);
                }
            }

            Integer costIdx = columnIndex.get("Cost");
            Integer resourceIdIdx = columnIndex.get("ResourceId");
            Integer meterCategoryIdx = columnIndex.get("MeterCategory");
            Integer meterSubCategoryIdx = columnIndex.get("MeterSubCategory");
            Integer meterIdx = columnIndex.get("Meter");
            Integer resourceLocationIdx = columnIndex.get("ResourceLocation");
            Integer pricingModelIdx = columnIndex.get("PricingModel");
            Integer benefitNameIdx = columnIndex.get("BenefitName");
            Integer serviceNameIdx = columnIndex.get("ServiceName");
            Integer serviceTierIdx = columnIndex.get("ServiceTier");

            for (List<Object> row : result.rows()) {
                try {
                    RawCostRecordDto.RawCostRecordDtoBuilder builder = RawCostRecordDto.builder();

                    if (costIdx != null && row.size() > costIdx) {
                        BigDecimal cost = BigDecimal.valueOf(parseDouble(row.get(costIdx)));
                        builder.cost(cost);
                    }
                    if (resourceIdIdx != null && row.size() > resourceIdIdx) {
                        Object val = row.get(resourceIdIdx);
                        builder.resourceId(val != null ? String.valueOf(val) : "");
                    }
                    if (meterCategoryIdx != null && row.size() > meterCategoryIdx) {
                        Object val = row.get(meterCategoryIdx);
                        builder.meterCategory(val != null ? String.valueOf(val) : "");
                    }
                    if (meterSubCategoryIdx != null && row.size() > meterSubCategoryIdx) {
                        Object val = row.get(meterSubCategoryIdx);
                        builder.meterSubCategory(val != null ? String.valueOf(val) : "");
                    }
                    if (meterIdx != null && row.size() > meterIdx) {
                        Object val = row.get(meterIdx);
                        builder.meterName(val != null ? String.valueOf(val) : "");
                    }
                    if (resourceLocationIdx != null && row.size() > resourceLocationIdx) {
                        Object val = row.get(resourceLocationIdx);
                        builder.resourceLocation(val != null ? String.valueOf(val) : "");
                    }
                    if (pricingModelIdx != null && row.size() > pricingModelIdx) {
                        Object val = row.get(pricingModelIdx);
                        builder.pricingModel(val != null ? String.valueOf(val) : "");
                    }
                    if (benefitNameIdx != null && row.size() > benefitNameIdx) {
                        Object val = row.get(benefitNameIdx);
                        builder.benefitName(val != null ? String.valueOf(val) : "");
                    }
                    if (serviceNameIdx != null && row.size() > serviceNameIdx) {
                        Object val = row.get(serviceNameIdx);
                        builder.serviceName(val != null ? String.valueOf(val) : "");
                    }
                    if (serviceTierIdx != null && row.size() > serviceTierIdx) {
                        Object val = row.get(serviceTierIdx);
                        builder.serviceTier(val != null ? String.valueOf(val) : "");
                    }

                    builder.currency("USD");
                    builder.date(date.toString());

                    rawCosts.add(builder.build());

                } catch (Exception e) {
                    log.warn("Error processing raw cost row: {}", e.getMessage());
                }
            }

            log.info("Fetched {} raw cost records for date: {}", rawCosts.size(), date);

        } catch (Exception e) {
            log.error("Failed to fetch raw costs for date: {}", date, e);
            throw new RuntimeException("Raw cost fetch failed", e);
        }

        return rawCosts;
    }

    public List<RawCostRecordDto> getAllRawCostsForDateRange(LocalDate startDate, LocalDate endDate) {
        String scope = "/subscriptions/" + subscriptionId;
        List<RawCostRecordDto> rawCosts = new ArrayList<>();

        log.info("Fetching ALL raw costs from {} to {}", startDate, endDate);

        try {
            QueryDefinition query = new QueryDefinition()
                    .withType(ExportType.ACTUAL_COST)
                    .withTimeframe(TimeframeType.CUSTOM)
                    .withTimePeriod(new QueryTimePeriod()
                            .withFrom(startDate.atStartOfDay().atOffset(ZoneOffset.UTC))
                            .withTo(endDate.atTime(23, 59, 59).atOffset(ZoneOffset.UTC)))
                    .withDataset(new QueryDataset()
                            .withGranularity(GranularityType.DAILY)
                            .withAggregation(new HashMap<String, QueryAggregation>() {{
                                put("totalCost", new QueryAggregation()
                                        .withName("Cost")
                                        .withFunction(FunctionType.SUM));
                            }})
                            .withGrouping(Arrays.asList(
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ResourceId"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("MeterCategory"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("MeterSubCategory"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("Meter"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ResourceLocation"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("PricingModel"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("BenefitName"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ServiceName"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ServiceTier")
                            )));

            QueryResult result = costManager.queries().usage(scope, query);

            if (result == null || result.rows() == null) {
                log.warn("No data returned from Azure for date range");
                return rawCosts;
            }

            Map<String, Integer> columnIndex = new HashMap<>();
            if (result.columns() != null) {
                for (int i = 0; i < result.columns().size(); i++) {
                    columnIndex.put(result.columns().get(i).name(), i);
                }
            }

            Integer costIdx = columnIndex.get("Cost");
            Integer resourceIdIdx = columnIndex.get("ResourceId");
            Integer meterCategoryIdx = columnIndex.get("MeterCategory");
            Integer meterSubCategoryIdx = columnIndex.get("MeterSubCategory");
            Integer meterIdx = columnIndex.get("Meter");
            Integer resourceLocationIdx = columnIndex.get("ResourceLocation");
            Integer pricingModelIdx = columnIndex.get("PricingModel");
            Integer benefitNameIdx = columnIndex.get("BenefitName");
            Integer serviceNameIdx = columnIndex.get("ServiceName");
            Integer serviceTierIdx = columnIndex.get("ServiceTier");

            for (List<Object> row : result.rows()) {
                try {
                    RawCostRecordDto.RawCostRecordDtoBuilder builder = RawCostRecordDto.builder();

                    if (costIdx != null && row.size() > costIdx) {
                        BigDecimal cost = BigDecimal.valueOf(parseDouble(row.get(costIdx)));
                        builder.cost(cost);
                    }
                    if (resourceIdIdx != null && row.size() > resourceIdIdx) {
                        Object val = row.get(resourceIdIdx);
                        builder.resourceId(val != null ? String.valueOf(val) : "");
                    }
                    if (meterCategoryIdx != null && row.size() > meterCategoryIdx) {
                        Object val = row.get(meterCategoryIdx);
                        builder.meterCategory(val != null ? String.valueOf(val) : "");
                    }
                    if (meterSubCategoryIdx != null && row.size() > meterSubCategoryIdx) {
                        Object val = row.get(meterSubCategoryIdx);
                        builder.meterSubCategory(val != null ? String.valueOf(val) : "");
                    }
                    if (meterIdx != null && row.size() > meterIdx) {
                        Object val = row.get(meterIdx);
                        builder.meterName(val != null ? String.valueOf(val) : "");
                    }
                    if (resourceLocationIdx != null && row.size() > resourceLocationIdx) {
                        Object val = row.get(resourceLocationIdx);
                        builder.resourceLocation(val != null ? String.valueOf(val) : "");
                    }
                    if (pricingModelIdx != null && row.size() > pricingModelIdx) {
                        Object val = row.get(pricingModelIdx);
                        builder.pricingModel(val != null ? String.valueOf(val) : "");
                    }
                    if (benefitNameIdx != null && row.size() > benefitNameIdx) {
                        Object val = row.get(benefitNameIdx);
                        builder.benefitName(val != null ? String.valueOf(val) : "");
                    }
                    if (serviceNameIdx != null && row.size() > serviceNameIdx) {
                        Object val = row.get(serviceNameIdx);
                        builder.serviceName(val != null ? String.valueOf(val) : "");
                    }
                    if (serviceTierIdx != null && row.size() > serviceTierIdx) {
                        Object val = row.get(serviceTierIdx);
                        builder.serviceTier(val != null ? String.valueOf(val) : "");
                    }

                    builder.currency("USD");
                    builder.date(startDate.toString());

                    rawCosts.add(builder.build());

                } catch (Exception e) {
                    log.warn("Error processing raw cost row: {}", e.getMessage());
                }
            }

            log.info("Fetched {} raw cost records for date range", rawCosts.size());

        } catch (Exception e) {
            log.error("Failed to fetch raw costs for date range", e);
            throw new RuntimeException("Raw cost fetch failed", e);
        }

        return rawCosts;
    }

    @Transactional
    public void syncDailyCostsFromAzure() {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        String scope = "/subscriptions/" + subscriptionId;

        log.info("========================================");
        log.info("Starting cost sync for date: {}", yesterday);
        log.info("========================================");

        try {
            // Build query with proper aggregation
            QueryDefinition query = new QueryDefinition()
                    .withType(ExportType.ACTUAL_COST)
                    .withTimeframe(TimeframeType.CUSTOM)
                    .withTimePeriod(new QueryTimePeriod()
                            .withFrom(yesterday.atStartOfDay().atOffset(ZoneOffset.UTC))
                            .withTo(yesterday.atTime(23, 59, 59).atOffset(ZoneOffset.UTC)))
                    .withDataset(new QueryDataset()
                            .withGranularity(GranularityType.DAILY)
                            .withAggregation(new HashMap<String, QueryAggregation>() {{
                                put("totalCost", new QueryAggregation()
                                        .withName("Cost")
                                        .withFunction(FunctionType.SUM));
                            }})
                            .withGrouping(Arrays.asList(
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ResourceId"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("MeterCategory"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("MeterSubCategory"),
                                    new QueryGrouping()
                                            .withType(QueryColumnType.DIMENSION)
                                            .withName("ResourceLocation")
                            ))
                    );

            QueryResult result = costManager.queries().usage(scope, query);

            if (result == null || result.rows() == null) {
                log.warn("No data returned from Azure");
                return;
            }

            // Map columns
            Map<String, Integer> columnIndex = new HashMap<>();
            if (result.columns() != null) {
                for (int i = 0; i < result.columns().size(); i++) {
                    columnIndex.put(result.columns().get(i).name(), i);
                }
            }

            Integer costIdx = columnIndex.get("Cost");
            Integer resourceIdIdx = columnIndex.get("ResourceId");
            Integer meterCategoryIdx = columnIndex.get("MeterCategory");
            Integer meterSubCategoryIdx = columnIndex.get("MeterSubCategory");

            if (costIdx == null || resourceIdIdx == null) {
                log.error("Required columns not found");
                return;
            }

            // Get all VMs and create lookup maps
            List<Vm> vms = vmRepository.findAll();

            // Create lookup maps
            Map<String, Vm> vmByNameCaseInsensitive = new HashMap<>();
            Map<String, Vm> vmByAzureIdNormalized = new HashMap<>();

            // Map VM UUID to VM (extracted from Azure VM ID or from VM name patterns)
            Map<String, Vm> vmByUuidMap = new HashMap<>();

            for (Vm vm : vms) {
                // Store by name (case insensitive)
                vmByNameCaseInsensitive.put(vm.getName().toLowerCase(), vm);

                // Normalize and store Azure VM ID
                if (vm.getAzureVmId() != null) {
                    String normalizedId = normalizeResourceId(vm.getAzureVmId());
                    vmByAzureIdNormalized.put(normalizedId, vm);
                }

                // For UUID matching, we need to map VM names to possible UUIDs from backup snapshots
                // The backup snapshots contain UUIDs that correspond to VM IDs from Azure
                // Since we don't have the UUIDs stored, we'll need to match by VM name patterns in the backup names
            }

            // Track statistics
            AtomicInteger totalRecords = new AtomicInteger(0);
            AtomicInteger vmMatched = new AtomicInteger(0);
            AtomicInteger savedRecords = new AtomicInteger(0);
            AtomicInteger skippedDuplicates = new AtomicInteger(0);
            AtomicInteger skippedZero = new AtomicInteger(0);
            AtomicInteger backupMatched = new AtomicInteger(0);

            Map<CostType, Double> costTypeTotal = new HashMap<>();
            Map<String, Double> vmCostTotals = new HashMap<>();

            // Process each row
            for (List<Object> row : result.rows()) {
                totalRecords.incrementAndGet();

                try {
                    Double amount = parseDouble(row.get(costIdx));
                    String resourceId = resourceIdIdx != null && row.get(resourceIdIdx) != null ?
                            String.valueOf(row.get(resourceIdIdx)) : null;
                    String meterCategory = meterCategoryIdx != null && row.get(meterCategoryIdx) != null ?
                            String.valueOf(row.get(meterCategoryIdx)) : null;
                    String meterSubCategory = meterSubCategoryIdx != null && row.get(meterSubCategoryIdx) != null ?
                            String.valueOf(row.get(meterSubCategoryIdx)) : null;

                    // Skip zero or tiny amounts
                    if (amount == null || amount <= 0.0 || amount < 0.0001) {
                        skippedZero.incrementAndGet();
                        continue;
                    }

                    // Find matching VM
                    Vm matchingVm = findMatchingVm(resourceId, meterCategory, meterSubCategory,
                            vmByNameCaseInsensitive, vmByAzureIdNormalized, vms);

                    if (matchingVm != null) {
                        vmMatched.incrementAndGet();

                        // Track if this was a backup match
                        if (resourceId != null && resourceId.toLowerCase().contains("snapshot")) {
                            backupMatched.incrementAndGet();
                        }

                        // Map to CostType (backup snapshots should be BACKUP type)
                        CostType costType = mapToCostType(meterCategory, meterSubCategory);

                        // Track totals
                        costTypeTotal.merge(costType, amount, Double::sum);
                        vmCostTotals.merge(matchingVm.getName(), amount, Double::sum);

                        // Check for duplicate
                        boolean exists = costRecordRepository
                                .findByVmIdAndDate(matchingVm.getId(), yesterday)
                                .stream()
                                .anyMatch(c -> c.getCostType() == costType);

                        if (!exists) {
                            CostRecord record = CostRecord.builder()
                                    .vm(matchingVm)
                                    .costType(costType)
                                    .amount(amount)
                                    .currency("USD")
                                    .date(yesterday)
                                    .build();
                            costRecordRepository.save(record);
                            savedRecords.incrementAndGet();
                        } else {
                            skippedDuplicates.incrementAndGet();
                        }
                    }
                    // Skip logging unmatched costs

                } catch (Exception e) {
                    log.error("Error processing row: {}", e.getMessage());
                }
            }

            // Print summary
            log.info("========================================");
            log.info("COST SYNC SUMMARY for {}", yesterday);
            log.info("========================================");
            log.info("Total records: {}", totalRecords.get());
            log.info("Records saved: {} (VM matched: {})", savedRecords.get(), vmMatched.get());
            log.info("  - Backup snapshots matched: {}", backupMatched.get());
            log.info("Duplicates skipped: {}", skippedDuplicates.get());
            log.info("Zero/small amounts skipped: {}", skippedZero.get());
            log.info("");
            log.info("COST BREAKDOWN BY TYPE:");
            for (Map.Entry<CostType, Double> entry : costTypeTotal.entrySet()) {
                log.info("  {}: ${:.2f}", entry.getKey(), entry.getValue());
            }
            log.info("");
            log.info("COST BREAKDOWN BY VM:");
            for (Map.Entry<String, Double> entry : vmCostTotals.entrySet()) {
                log.info("  {}: ${:.2f}", entry.getKey(), entry.getValue());
            }
            log.info("========================================");

        } catch (Exception e) {
            log.error("Failed to sync costs", e);
            throw new RuntimeException("Azure cost sync failed", e);
        }
    }

    /**
     * Find matching VM using multiple strategies including backup snapshots
     */
    private Vm findMatchingVm(String resourceId, String meterCategory, String meterSubCategory,
                              Map<String, Vm> vmByNameCaseInsensitive,
                              Map<String, Vm> vmByAzureIdNormalized,
                              List<Vm> allVms) {
        if (resourceId == null) return null;

        String normalizedResourceId = normalizeResourceId(resourceId);
        String lowerResourceId = resourceId.toLowerCase();

        // Strategy 1: Direct match by normalized Azure VM ID
        Vm vm = vmByAzureIdNormalized.get(normalizedResourceId);
        if (vm != null) return vm;

        // Strategy 2: Extract VM name from resource ID
        String extractedVmName = extractVmName(resourceId);
        if (extractedVmName != null) {
            vm = vmByNameCaseInsensitive.get(extractedVmName.toLowerCase());
            if (vm != null) return vm;
        }

        // Strategy 3: For backup snapshots - try to extract VM name from the snapshot name
        if (lowerResourceId.contains("snapshots") && lowerResourceId.contains("azurebackup")) {
            String vmNameFromBackup = extractVmNameFromBackupSnapshot(lowerResourceId, allVms);
            if (vmNameFromBackup != null) {
                vm = vmByNameCaseInsensitive.get(vmNameFromBackup.toLowerCase());
                if (vm != null) return vm;
            }
        }

        // Strategy 4: For disks - try to extract VM name from disk name
        if (lowerResourceId.contains("disks")) {
            String vmNameFromDisk = extractVmNameFromDisk(lowerResourceId);
            if (vmNameFromDisk != null) {
                vm = vmByNameCaseInsensitive.get(vmNameFromDisk.toLowerCase());
                if (vm != null) return vm;
            }
        }

        // Strategy 5: For public IPs
        if (lowerResourceId.contains("publicipaddresses")) {
            java.util.regex.Matcher matcher = PUBLIC_IP_PATTERN.matcher(resourceId);
            if (matcher.find()) {
                String ipName = matcher.group(1);
                String possibleVmName = ipName.replace("-ip", "").replace("-publicip", "");
                vm = vmByNameCaseInsensitive.get(possibleVmName.toLowerCase());
                if (vm != null) return vm;
            }
        }

        // Strategy 6: For log analytics
        if (lowerResourceId.contains("workspaces")) {
            java.util.regex.Matcher matcher = LOG_ANALYTICS_PATTERN.matcher(resourceId);
            if (matcher.find()) {
                String workspaceName = matcher.group(1);
                String possibleVmName = workspaceName.replace("-loganalytics", "");
                vm = vmByNameCaseInsensitive.get(possibleVmName.toLowerCase());
                if (vm != null) return vm;
            }
        }

        return null;
    }

    /**
     * Extract VM name from backup snapshot name
     * Backup snapshots have names like: azurebackup_46404923-8921-48d2-a434-6f470b58f89d_2026-03-02t00-01-38.4536288
     * The UUID corresponds to a VM. We need to match this UUID to a VM by looking at disk names that contain the UUID
     */
    private String extractVmNameFromBackupSnapshot(String lowerResourceId, List<Vm> allVms) {
        // Extract UUID from backup snapshot name
        java.util.regex.Matcher uuidMatcher = BACKUP_VM_UUID_PATTERN.matcher(lowerResourceId);
        if (uuidMatcher.find()) {
            String uuid = uuidMatcher.group(1);

            // Try to find which VM this UUID belongs to by checking disk names
            // Disk names often contain the VM UUID: ltrms-db_osdisk_1_46404923892148d2a4346f470b58f89d
            String uuidWithoutDashes = uuid.replace("-", "");

            for (Vm vm : allVms) {
                // Check if the VM's disk names (in resourceId) contain this UUID
                if (vm.getAzureVmId() != null && vm.getAzureVmId().toLowerCase().contains(uuidWithoutDashes)) {
                    return vm.getName();
                }
            }

            // Try to match by common VM names based on the UUID pattern
            // For LTRMS-db, the UUID 46404923-8921-48d2-a434-6f470b58f89d appears in its disk
            if (uuidWithoutDashes.contains("46404923892148d2a4346f470b58f89d")) {
                return "LTRMS-db";
            }
            if (uuidWithoutDashes.contains("9c6d61e8f0864c04a5dc395ac6403947")) {
                return "LTRMS-Externe";
            }
            if (uuidWithoutDashes.contains("8372b49aae284b109314130f93b9844d")) {
                return "LTRMS-Interne";
            }
            if (uuidWithoutDashes.contains("f4f3890107db467aa19917f8ab6f0b4d")) {
                return "Takwinland-db";
            }
            if (uuidWithoutDashes.contains("820330395fdb440c8837d68cd81264f3")) {
                return "Takwinland";
            }
        }
        return null;
    }

    /**
     * Extract VM name from disk resource ID
     */
    private String extractVmNameFromDisk(String lowerResourceId) {
        java.util.regex.Matcher diskMatcher = DISK_PATTERN.matcher(lowerResourceId);
        if (diskMatcher.find()) {
            String diskName = diskMatcher.group(1);
            if (diskName.contains("_osdisk")) {
                return diskName.split("_osdisk")[0];
            }
            if (diskName.contains("_disk")) {
                return diskName.split("_disk")[0];
            }
            return diskName;
        }
        return null;
    }

    /**
     * Normalize resource ID for case-insensitive matching
     */
    private String normalizeResourceId(String resourceId) {
        if (resourceId == null) return null;
        return resourceId.toLowerCase();
    }

    /**
     * Extract VM name from various Azure resource IDs
     */
    private String extractVmName(String resourceId) {
        if (resourceId == null) return null;

        String lowerResourceId = resourceId.toLowerCase();

        // Check for direct VM
        java.util.regex.Matcher vmMatcher = VM_PATTERN.matcher(lowerResourceId);
        if (vmMatcher.find()) {
            return vmMatcher.group(1);
        }

        // Check for disks
        java.util.regex.Matcher diskMatcher = DISK_PATTERN.matcher(lowerResourceId);
        if (diskMatcher.find()) {
            String diskName = diskMatcher.group(1);
            if (diskName.contains("_osdisk")) {
                return diskName.split("_osdisk")[0];
            }
            if (diskName.contains("_disk")) {
                return diskName.split("_disk")[0];
            }
            return diskName;
        }

        return null;
    }

    /**
     * Map Azure categories to CostType
     */
    private CostType mapToCostType(String meterCategory, String meterSubCategory) {
        if (meterCategory == null) return CostType.OTHER;

        String category = meterCategory.toLowerCase();
        String subCategory = meterSubCategory != null ? meterSubCategory.toLowerCase() : "";

        // Check for backup/snapshot first
        if (subCategory.contains("snapshot") || subCategory.contains("backup") ||
                category.contains("snapshot") || category.contains("backup")) {
            return CostType.BACKUP;
        }

        if (category.contains("virtual machines") || category.contains("compute")) {
            return CostType.COMPUTE;
        }
        if (category.contains("storage")) {
            return CostType.DISK;
        }
        if (category.contains("ip address") || category.contains("public ip") ||
                category.contains("virtual network") && subCategory.contains("ip")) {
            return CostType.PUBLIC_IP;
        }
        if (category.contains("bandwidth") || category.contains("network") ||
                category.contains("data transfer") || category.contains("network watcher")) {
            return CostType.NETWORK;
        }
        if (category.contains("log analytics") || category.contains("azure monitor")) {
            return CostType.OTHER;
        }
        if (category.contains("automation")) {
            return CostType.OTHER;
        }

        return CostType.OTHER;
    }

    private Double parseDouble(Object obj) {
        if (obj == null) return 0.0;
        try {
            if (obj instanceof Number) {
                return ((Number) obj).doubleValue();
            }
            return Double.parseDouble(obj.toString());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}