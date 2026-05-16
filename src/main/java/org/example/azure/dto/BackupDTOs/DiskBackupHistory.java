package org.example.azure.dto.BackupDTOs;

import lombok.Data;
import java.util.List;

@Data
public class DiskBackupHistory {
    private String diskName;
    private String protectionStatus;
    private String vaultName;
    private String dataSourceType;
    private List<BackupRecord> backupHistory;
}