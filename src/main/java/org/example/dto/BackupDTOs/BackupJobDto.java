package org.example.dto.BackupDTOs;

import lombok.Data;

@Data
public class BackupJobDto {
    private String jobId;
    private String jobName;
    private String operation;
    private String status;
    private String startTime;
    private String endTime;
    private String duration;
    private Boolean isUserTriggered;
    private String errorCode;
    private String errorMessage;
}