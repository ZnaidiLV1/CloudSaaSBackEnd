package org.example.ai.dto.request.DiskAIRequestDTOs;

import lombok.Data;
import java.util.List;

@Data
public class BatchDiskRequestDTO {
    private List<VmDiskData> vms;

    @Data
    public static class VmDiskData {
        private Long vmId;
        private String vmName;
        private Double totalGB;
        private Double freeGB;
        private Double freePercent;
        private Double avgDailyWriteMB;
        private Double peakDailyWriteMB;
        private String writeTrend;
        private String vmType;
    }
}