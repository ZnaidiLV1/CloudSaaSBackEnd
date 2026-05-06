package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.config.SchedulerConfig;
import org.example.dto.BackupDTOs.VmBackupHistoryResponse;
import org.example.dto.backupDTOS.BackupVaultWithItemsDTO;
import org.example.entity.BackupVault;
import org.example.entity.ProtectedItem;
import org.example.repository.BackupVaultRepository;
import org.example.repository.ProtectedItemRepository;
import org.example.service.BackupService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class BackupResolver {

    private final BackupService backupService;
    private final BackupVaultRepository backupVaultRepository;
    private final ProtectedItemRepository protectedItemRepository;
    private final SchedulerConfig schedulerConfig;

    @MutationMapping
    public String syncBackupData() {
        log.info("Triggering backup data sync...");
        schedulerConfig.updateStatusOnly("backup", "RUNNING");
        try {
            String result = backupService.syncAllBackupData();
            schedulerConfig.updateExecutionStatus("backup", LocalDateTime.now(), "SUCCESS");
            return result;
        } catch (Exception e) {
            schedulerConfig.updateStatusOnly("backup", "FAILED");
            throw e;
        }
    }

    @QueryMapping
    public List<BackupVault> getAllBackupVaults() {
        return backupVaultRepository.findAll();
    }

    @QueryMapping
    public BackupVault getBackupVaultByName(@Argument String vaultName) {
        return backupVaultRepository.findByVaultName(vaultName).orElse(null);
    }

    @QueryMapping
    public List<ProtectedItem> getProtectedItemsByStatus(@Argument String protectionStatus) {
        return protectedItemRepository.findByProtectionStatusAndIsActiveTrue(protectionStatus);
    }

    @QueryMapping
    public VmBackupHistoryResponse getVmBackupHistoryByDateRange(
            @Argument Long vmId,
            @Argument String startDate,
            @Argument String endDate) {
        log.info("Fetching backup history for VM ID: {} from {} to {}", vmId, startDate, endDate);
        return backupService.getVmBackupHistoryByDateRange(vmId, startDate, endDate);
    }

    @MutationMapping
    public String syncBackupHistoryLast30Days() {
        log.info("Triggering backup history sync for last 30 days...");
        return backupService.syncBackupHistoryLast30Days();
    }

    @QueryMapping
    public List<BackupVaultWithItemsDTO> getAllBackupVaultsWithItems() {
        return backupService.getAllBackupVaultsWithItems();
    }


}