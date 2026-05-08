package org.example.dto.backupDTOS;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class VmDiskSpaceResult {

    private String vmId;
    private String vmName;
    private List<DiskMetric> disks;
    private String queryTime;

    @Data
    @Builder
    public static class DiskMetric {
        private String diskName;
        private Double freeSpacePercent;
        private Double freeSpaceMB;
        private Double freeSpaceGB;
    }
}