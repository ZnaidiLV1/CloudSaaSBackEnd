package org.example.ai.dto.request.RamCpuAIRequestsDTOs;

import lombok.Data;
import java.util.List;

@Data
public class BatchCpuRamRequestDTO {
    private List<VmCpuRamData> vms;

    @Data
    public static class VmCpuRamData {
        private Long vmId;
        private String vmName;
        private List<DailyCpuRam> dailyData;
    }

    @Data
    public static class DailyCpuRam {
        private String date;
        private Double maxCpuPercent;
        private String cpuPeakTime;
        private Double maxUsedRamPercent;
        private String ramPeakTime;
    }
}