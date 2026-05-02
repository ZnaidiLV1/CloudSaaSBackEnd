package org.example.dto.BackupDTOs;

import lombok.Data;

@Data
public class ProtectedItemDto {
    private String backupInstanceId;
    private String dataSourceName;
    private String dataSourceType;
    private String dataSourceId;
    private String friendlyName;
    private String policyName;
    private String protectionStatus;
}