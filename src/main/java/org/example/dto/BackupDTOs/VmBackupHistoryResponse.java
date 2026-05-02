package org.example.dto.BackupDTOs;

import lombok.Data;
import org.example.dto.BackupDTOs.DiskBackupHistory;

import java.util.List;

@Data
public class VmBackupHistoryResponse {
    private Long vmId;
    private String vmName;
    private String startDate;
    private String endDate;
    private List<DiskBackupHistory> disks;
}