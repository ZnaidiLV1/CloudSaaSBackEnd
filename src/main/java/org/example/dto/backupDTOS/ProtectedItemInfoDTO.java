package org.example.dto.backupDTOS;

import lombok.Data;

@Data
public class ProtectedItemInfoDTO {
    private String dataSourceName;
    private String protectionStatus;
    private String vmName;
    private Long vmId;
}