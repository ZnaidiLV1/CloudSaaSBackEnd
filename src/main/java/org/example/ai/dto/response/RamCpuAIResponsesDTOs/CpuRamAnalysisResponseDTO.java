package org.example.ai.dto.response.RamCpuAIResponsesDTOs;

import lombok.Data;
import java.util.List;

@Data
public class CpuRamAnalysisResponseDTO {
    private List<VmCpuRamAnalysis> analyses;

    @Data
    public static class VmCpuRamAnalysis {
        private Long vmId;
        private String vmName;
        private CpuPattern cpuPattern;
        private RamPattern ramPattern;
        private Anomaly anomaly;
        private Recommendation recommendation;
    }

    @Data
    public static class CpuPattern {
        private Boolean hasPattern;
        private String description;
        private String peakDay;
        private Integer peakHour;
        private String severity;
    }

    @Data
    public static class RamPattern {
        private Boolean hasPattern;
        private String description;
        private String severity;
    }

    @Data
    public static class Anomaly {
        private Boolean detected;
        private String details;
    }

    @Data
    public static class Recommendation {
        private String action;
        private String suggestion;
    }
}