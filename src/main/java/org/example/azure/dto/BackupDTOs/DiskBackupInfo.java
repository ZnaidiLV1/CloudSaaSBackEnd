package org.example.azure.dto.BackupDTOs;

import lombok.Data;

@Data
public class DiskBackupInfo {
    private String diskName;
    private String protectionStatus;
    private String lastBackupStatus;
    private String lastBackupTime;
    private String lastBackupDuration;
    private String backupVaultName;
    private String statusColor;
    private String statusMessage;
}