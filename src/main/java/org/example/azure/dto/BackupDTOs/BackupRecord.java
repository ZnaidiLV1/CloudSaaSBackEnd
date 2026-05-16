package org.example.azure.dto.BackupDTOs;

import lombok.Data;

@Data
public class BackupRecord {
    private String date;
    private String status;
    private String duration;
    private String startTime;
}