package org.example.service;

import com.azure.core.http.rest.PagedIterable;
import com.azure.resourcemanager.dataprotection.DataProtectionManager;
import com.azure.resourcemanager.dataprotection.models.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.BackupDTOs.BackupRecord;
import org.example.dto.BackupDTOs.DiskBackupHistory;
import org.example.dto.BackupDTOs.VmBackupHistoryResponse;
import org.example.dto.BackupDTOs.BackupVaultWithItemsDTO;
import org.example.dto.BackupDTOs.ProtectedItemInfoDTO;
import org.example.entity.*;
import org.example.entity.BackupVault;
import org.example.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class BackupService {

    private final DataProtectionManager dataProtectionManager;
    private final BackupVaultRepository backupVaultRepository;
    private final ProtectedItemRepository protectedItemRepository;
    private final BackupJobHistoryRepository backupJobHistoryRepository;
    private final VmRepository vmRepository;

    

    @Transactional
    public String syncAllBackupData() {
        log.info("Starting backup data sync...");

        LocalDateTime now = LocalDateTime.now();
        OffsetDateTime todayStart = OffsetDateTime.now(ZoneOffset.UTC)
                .withHour(0).withMinute(0).withSecond(0).withNano(0);
        OffsetDateTime todayEnd = todayStart.plusDays(1);

        PagedIterable<BackupVaultResource> azureVaults = dataProtectionManager.backupVaults().list();

        for (BackupVaultResource azureVault : azureVaults) {
            BackupVault vault = syncBackupVault(azureVault, now);
            if (vault != null) {
                syncProtectedItems(azureVault, vault, now);
                syncBackupJobsForVault(vault, azureVault.resourceGroupName(), todayStart, todayEnd);
            }
        }

        log.info("Backup data sync completed");
        return "Backup sync completed successfully";
    }

    private BackupVault syncBackupVault(BackupVaultResource azureVault, LocalDateTime now) {
        String tags = azureVault.tags() != null ? azureVault.tags().toString() : null;
        String storageType = null;
        String datastoreType = null;

        if (azureVault.properties() != null && azureVault.properties().storageSettings() != null
                && !azureVault.properties().storageSettings().isEmpty()) {
            storageType = azureVault.properties().storageSettings().get(0).type() != null
                    ? azureVault.properties().storageSettings().get(0).type().toString() : null;
            datastoreType = azureVault.properties().storageSettings().get(0).datastoreType() != null
                    ? azureVault.properties().storageSettings().get(0).datastoreType().toString() : null;
        }

        log.info("Fields Being Saved to Database:");
        log.info("  - vaultName: {}", azureVault.name());
        log.info("  - resourceGroup: {}", azureVault.resourceGroupName());
        log.info("  - location: {}", azureVault.location());
        log.info("  - storageType: {}", storageType);
        log.info("  - tags: {}", tags);
        log.info("  - createdAt/updatedAt: {}", now);

        log.info("MISSING FIELDS (Azure provides but NOT saving to DB):");
        log.info("  - provisioningState: {}", azureVault.properties() != null ? azureVault.properties().provisioningState() : "N/A");
        log.info("  - softDelete settings: {}", azureVault.properties() != null && azureVault.properties().securitySettings() != null);
        log.info("  - crossRegionRestore: {}", azureVault.properties() != null && azureVault.properties().featureSettings() != null);
        log.info("  - systemData (createdBy, createdAt, lastModifiedAt): {}", azureVault.systemData() != null ? "AVAILABLE" : "N/A");
        log.info("  - datastoreType: {}", datastoreType);
        log.info("  - identity: {}", azureVault.identity() != null ? azureVault.identity().principalId() : "N/A");
        log.info("  - etag: {}", azureVault.etag());

        BackupVault existing = backupVaultRepository.findByVaultName(azureVault.name()).orElse(null);

        if (existing == null) {
            BackupVault newVault = BackupVault.builder()
                    .vaultName(azureVault.name())
                    .resourceGroup(azureVault.resourceGroupName())
                    .location(azureVault.location())
                    .storageType(storageType)
                    .tags(tags)
                    .createdAt(now)
                    .updatedAt(now)
                    .build();
            backupVaultRepository.save(newVault);
            log.info("✅ ADDED new backup vault: {}", azureVault.name());
            return newVault;
        } else {
            existing.setStorageType(storageType);
            existing.setTags(tags);
            existing.setUpdatedAt(now);
            backupVaultRepository.save(existing);
            log.info("✅ UPDATED backup vault: {}", azureVault.name());
            return existing;
        }
    }

    private void syncProtectedItems(BackupVaultResource azureVault, BackupVault vault, LocalDateTime now) {
        log.info("=== Syncing Protected Items for Vault: {} ===", vault.getVaultName());

        protectedItemRepository.deactivateAllByVaultId(vault.getId());

        PagedIterable<BackupInstanceResource> azureInstances = dataProtectionManager
                .backupInstances()
                .list(azureVault.resourceGroupName(), azureVault.name());

        int totalInstances = 0;
        for (BackupInstanceResource instance : azureInstances) {
            totalInstances++;
            log.info("--- Protected Instance {} ---", totalInstances);
            log.info("Azure Raw Data:");
            log.info("  - Instance ID: {}", instance.id());
            log.info("  - Instance Name: {}", instance.name());
            log.info("  - Type: {}", instance.type());

            if (instance.properties() == null) {
                log.warn("  - No properties found for this instance");
                continue;
            }

            BackupInstance props = instance.properties();

            log.info("  - Protection Status: {}", props.protectionStatus() != null ? props.protectionStatus().status() : "N/A");
            log.info("  - Current Protection State: {}", props.currentProtectionState());
            log.info("  - Protection Error Details: {}", props.protectionErrorDetails());

            String backupInstanceId = extractLastSegment(instance.id());
            String dataSourceName = null;
            String dataSourceType = null;
            String resourceId = null;

            if (props.dataSourceInfo() != null) {
                dataSourceName = extractLastSegment(props.dataSourceInfo().resourceId());
                resourceId = props.dataSourceInfo().resourceId();
                dataSourceType = props.dataSourceInfo().objectType();
                if (dataSourceType != null && dataSourceType.contains("/")) {
                    dataSourceType = dataSourceType.substring(dataSourceType.lastIndexOf("/") + 1);
                }
                log.info("  - Data Source Name: {}", dataSourceName);
                log.info("  - Data Source Resource ID: {}", resourceId);
                log.info("  - Data Source Type: {}", dataSourceType);
                log.info("  - Data Source Location: {}", props.dataSourceInfo().resourceLocation());
            }

            if (props.policyInfo() != null) {
                log.info("  - Policy ID: {}", props.policyInfo().policyId());
                if (props.policyInfo().policyParameters() != null) {
                    log.info("  - Policy Parameters: {}", props.policyInfo().policyParameters());
                }
            }

            log.info("  - Object Type: {}", props.objectType());

            Vm linkedVm = findVmByDiskName(dataSourceName);
            log.info("  - Linked VM in Database: {}", linkedVm != null ? linkedVm.getName() : "NOT FOUND");

            Optional<ProtectedItem> existing = protectedItemRepository.findByBackupInstanceId(backupInstanceId);

            if (existing.isEmpty()) {
                ProtectedItem newItem = ProtectedItem.builder()
                        .backupVault(vault)
                        .vm(linkedVm)
                        .backupInstanceId(backupInstanceId)
                        .dataSourceName(dataSourceName)
                        .dataSourceType(dataSourceType)
                        .protectionStatus(props.protectionStatus() != null && props.protectionStatus().status() != null
                                ? props.protectionStatus().status().toString() : null)
                        .isActive(true)
                        .firstDetectedAt(now)
                        .lastSeenAt(now)
                        .build();
                protectedItemRepository.save(newItem);
                log.info("  ✅ ADDED protected item: {}", dataSourceName);
            } else {
                ProtectedItem item = existing.get();
                item.setVm(linkedVm);
                item.setDataSourceName(dataSourceName);
                item.setDataSourceType(dataSourceType);
                item.setProtectionStatus(props.protectionStatus() != null && props.protectionStatus().status() != null
                        ? props.protectionStatus().status().toString() : null);
                item.setIsActive(true);
                item.setLastSeenAt(now);
                protectedItemRepository.save(item);
                log.info("  ✅ UPDATED protected item: {}", dataSourceName);
            }
        }

        log.info("=== Total Protected Items Synced for Vault {}: {} ===", vault.getVaultName(), totalInstances);
    }

    private void syncBackupJobsForVault(BackupVault vault, String resourceGroup, OffsetDateTime todayStart, OffsetDateTime todayEnd) {
        List<ProtectedItem> activeItems = protectedItemRepository.findByBackupVaultIdAndIsActiveTrue(vault.getId());

        PagedIterable<AzureBackupJobResource> azureJobs = dataProtectionManager
                .jobs()
                .list(resourceGroup, vault.getVaultName());

        for (AzureBackupJobResource azureJob : azureJobs) {
            AzureBackupJob props = azureJob.properties();
            if (props == null || props.startTime() == null) continue;

            OffsetDateTime jobTime = props.startTime();
            if (jobTime.isBefore(todayStart) || !jobTime.isBefore(todayEnd)) continue;

            String dataSourceName = props.dataSourceName();
            ProtectedItem matchingItem = activeItems.stream()
                    .filter(item -> dataSourceName != null && dataSourceName.equals(item.getDataSourceName()))
                    .findFirst()
                    .orElse(null);

            if (matchingItem == null) continue;

            if (!"ProtectionConfigured".equals(matchingItem.getProtectionStatus())) {
                continue;
            }

            String jobId = extractLastSegment(azureJob.id());
            if (backupJobHistoryRepository.findByJobId(jobId).isPresent()) {
                continue;
            }

            String duration = null;
            if (props.duration() != null) {
                try {
                    Duration d = Duration.parse(props.duration());
                    long seconds = d.getSeconds();
                    long minutes = (seconds % 3600) / 60;
                    long secs = seconds % 60;
                    if (minutes > 0) {
                        duration = String.format("%d minutes, %d seconds", minutes, secs);
                    } else {
                        duration = String.format("%d seconds", secs);
                    }
                } catch (Exception e) {
                    duration = props.duration();
                }
            }

            BackupJobHistory jobHistory = BackupJobHistory.builder()
                    .protectedItem(matchingItem)
                    .jobId(jobId)
                    .status(props.status())
                    .startTime(props.startTime() != null ? props.startTime().toLocalDateTime() : null)
                    .duration(duration)
                    .syncedAt(LocalDateTime.now())
                    .build();

            backupJobHistoryRepository.save(jobHistory);
            log.info("Saved backup job for: {} - Status: {}", dataSourceName, props.status());
        }
    }

    public VmBackupHistoryResponse getVmBackupHistoryByDateRange(Long vmId, String startDate, String endDate) {
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);
        LocalDateTime startDateTime = start.atStartOfDay();
        LocalDateTime endDateTime = end.atTime(23, 59, 59);

        Optional<Vm> vmOpt = vmRepository.findById(vmId);
        if (vmOpt.isEmpty()) {
            VmBackupHistoryResponse response = new VmBackupHistoryResponse();
            response.setVmId(vmId);
            response.setVmName("Unknown");
            response.setStartDate(startDate);
            response.setEndDate(endDate);
            response.setDisks(new ArrayList<>());
            return response;
        }

        Vm vm = vmOpt.get();
        List<ProtectedItem> protectedItems = protectedItemRepository.findByVmIdWithVault(vmId);

        if (protectedItems.isEmpty()) {
            VmBackupHistoryResponse response = new VmBackupHistoryResponse();
            response.setVmId(vm.getId());
            response.setVmName(vm.getName());
            response.setStartDate(startDate);
            response.setEndDate(endDate);
            response.setDisks(new ArrayList<>());
            return response;
        }

        List<DiskBackupHistory> disks = new ArrayList<>();

        for (ProtectedItem item : protectedItems) {
            if (!"ProtectionConfigured".equals(item.getProtectionStatus())) {
                continue;
            }

            DiskBackupHistory diskInfo = new DiskBackupHistory();
            diskInfo.setDiskName(item.getDataSourceName());
            diskInfo.setProtectionStatus(item.getProtectionStatus());
            diskInfo.setVaultName(item.getBackupVault().getVaultName());
            diskInfo.setDataSourceType(item.getDataSourceType());

            List<BackupJobHistory> jobs = backupJobHistoryRepository
                    .findByProtectedItemIdAndStartTimeBetweenOrderByStartTimeDesc(
                            item.getId(), startDateTime, endDateTime);

            List<BackupRecord> backupHistory = new ArrayList<>();
            for (BackupJobHistory job : jobs) {
                BackupRecord record = new BackupRecord();
                record.setDate(job.getStartTime() != null ? job.getStartTime().toLocalDate().toString() : null);
                record.setStatus(job.getStatus());
                record.setDuration(job.getDuration());
                record.setStartTime(job.getStartTime() != null ? job.getStartTime().toString() : null);
                backupHistory.add(record);
            }

            diskInfo.setBackupHistory(backupHistory);
            disks.add(diskInfo);
        }

        VmBackupHistoryResponse response = new VmBackupHistoryResponse();
        response.setVmId(vm.getId());
        response.setVmName(vm.getName());
        response.setStartDate(startDate);
        response.setEndDate(endDate);
        response.setDisks(disks);

        return response;
    }

    private LocalDate parseDate(String dateStr) {
        try {
            return LocalDate.parse(dateStr);
        } catch (DateTimeParseException e1) {
            try {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                return LocalDate.parse(dateStr, formatter);
            } catch (DateTimeParseException e2) {
                throw new RuntimeException("Invalid date format. Expected yyyy-MM-dd or dd/MM/yyyy. Got: " + dateStr);
            }
        }
    }

    public String syncBackupHistoryLast30Days() {
        log.info("Starting backup history sync for last 30 days...");

        int totalSaved = 0;
        int totalSkipped = 0;

        LocalDate endDate = LocalDate.now();
        LocalDate startDate = endDate.minusDays(30);

        for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
            LocalDateTime startOfDay = date.atStartOfDay();
            LocalDateTime endOfDay = date.atTime(23, 59, 59);

            OffsetDateTime startUTC = startOfDay.atZone(ZoneOffset.UTC).toOffsetDateTime();
            OffsetDateTime endUTC = endOfDay.atZone(ZoneOffset.UTC).toOffsetDateTime();

            log.info("Syncing date: {}", date);

            PagedIterable<BackupVaultResource> azureVaults = dataProtectionManager.backupVaults().list();

            for (BackupVaultResource azureVault : azureVaults) {
                BackupVault vault = backupVaultRepository.findByVaultName(azureVault.name()).orElse(null);
                if (vault == null) continue;

                List<ProtectedItem> activeItems = protectedItemRepository.findByBackupVaultIdAndIsActiveTrue(vault.getId());

                PagedIterable<AzureBackupJobResource> azureJobs = dataProtectionManager
                        .jobs()
                        .list(azureVault.resourceGroupName(), azureVault.name());

                for (AzureBackupJobResource azureJob : azureJobs) {
                    AzureBackupJob props = azureJob.properties();
                    if (props == null || props.startTime() == null) continue;

                    OffsetDateTime jobTime = props.startTime();
                    if (jobTime.isBefore(startUTC) || jobTime.isAfter(endUTC)) continue;

                    String dataSourceName = props.dataSourceName();
                    ProtectedItem matchingItem = activeItems.stream()
                            .filter(item -> dataSourceName != null && dataSourceName.equals(item.getDataSourceName()))
                            .findFirst()
                            .orElse(null);

                    if (matchingItem == null) continue;

                    if (!"ProtectionConfigured".equals(matchingItem.getProtectionStatus())) continue;

                    String jobId = extractLastSegment(azureJob.id());

                    if (backupJobHistoryRepository.findByJobId(jobId).isPresent()) {
                        totalSkipped++;
                        continue;
                    }

                    String duration = null;
                    if (props.duration() != null) {
                        try {
                            Duration d = Duration.parse(props.duration());
                            long seconds = d.getSeconds();
                            long minutes = (seconds % 3600) / 60;
                            long secs = seconds % 60;
                            if (minutes > 0) {
                                duration = String.format("%d minutes, %d seconds", minutes, secs);
                            } else {
                                duration = String.format("%d seconds", secs);
                            }
                        } catch (Exception e) {
                            duration = props.duration();
                        }
                    }

                    BackupJobHistory jobHistory = BackupJobHistory.builder()
                            .protectedItem(matchingItem)
                            .jobId(jobId)
                            .status(props.status())
                            .startTime(props.startTime() != null ? props.startTime().toLocalDateTime() : null)
                            .duration(duration)
                            .syncedAt(LocalDateTime.now())
                            .build();

                    backupJobHistoryRepository.save(jobHistory);
                    totalSaved++;
                }
            }
        }

        String result = String.format("Backup history sync completed. Saved: %d, Skipped (duplicates): %d", totalSaved, totalSkipped);
        log.info(result);
        return result;
    }

    @Transactional
    public List<BackupVaultWithItemsDTO> getAllBackupVaultsWithItems() {
        List<BackupVault> vaults = backupVaultRepository.findAll();

        return vaults.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    private BackupVaultWithItemsDTO convertToDTO(BackupVault vault) {
        BackupVaultWithItemsDTO dto = new BackupVaultWithItemsDTO();

        dto.setVaultName(vault.getVaultName());
        dto.setResourceGroup(vault.getResourceGroup());
        dto.setLocation(vault.getLocation());
        dto.setStorageType(vault.getStorageType());

        List<ProtectedItem> items = protectedItemRepository.findByBackupVaultIdAndIsActiveTrue(vault.getId());

        List<ProtectedItemInfoDTO> itemDTOs = items.stream()
                .map(this::convertItemToDTO)
                .collect(Collectors.toList());

        dto.setProtectedItems(itemDTOs);

        return dto;
    }

    private ProtectedItemInfoDTO convertItemToDTO(ProtectedItem item) {
        ProtectedItemInfoDTO dto = new ProtectedItemInfoDTO();

        dto.setDataSourceName(item.getDataSourceName());
        dto.setProtectionStatus(item.getProtectionStatus());

        if (item.getVm() != null) {
            dto.setVmName(item.getVm().getName());
            dto.setVmId(item.getVm().getId());
        }

        return dto;
    }

    private Vm findVmByDiskName(String diskName) {
        if (diskName == null) return null;

        String vmName = extractVmNameFromDiskName(diskName);
        if (vmName == null) return null;

        return vmRepository.findByName(vmName).orElse(null);
    }

    private String extractVmNameFromDiskName(String diskName) {
        if (diskName == null) return null;

        String[] patterns = {"_OsDisk", "_Os_Disk"};
        for (String pattern : patterns) {
            int index = diskName.indexOf(pattern);
            if (index > 0) {
                return diskName.substring(0, index);
            }
        }
        return diskName;
    }

    private String extractLastSegment(String resourceId) {
        if (resourceId == null || resourceId.isBlank()) return "Unknown";
        String[] parts = resourceId.split("/");
        return parts.length > 0 ? parts[parts.length - 1] : "Unknown";
    }
}