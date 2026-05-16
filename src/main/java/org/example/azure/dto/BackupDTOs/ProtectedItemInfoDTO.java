package org.example.azure.dto.BackupDTOs;

import lombok.Data;

@Data
public class ProtectedItemInfoDTO {
    private String dataSourceName;
    private String protectionStatus;
    private String vmName;
    private Long vmId;
    private BackupSummaryDTO lastBackup;
    private BackupSummaryDTO backup30DaysAgo;

    @Data
    public static class BackupSummaryDTO {
        private String status;
        private String startTime;
        private String duration;
    }
}