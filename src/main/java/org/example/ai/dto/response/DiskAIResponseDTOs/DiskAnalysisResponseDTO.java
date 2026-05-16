package org.example.ai.dto.response.DiskAIResponseDTOs;

import lombok.Data;
import java.util.List;

@Data
public class DiskAnalysisResponseDTO {
    private List<VmAnalysis> analyses;

    @Data
    public static class VmAnalysis {
        private Long vmId;
        private String vmName;
        private Prediction prediction;
        private Anomaly anomaly;
        private Optimization optimization;
    }

    @Data
    public static class Prediction {
        private int daysUntilFull;
        private String riskLevel;
        private String recommendation;
    }

    @Data
    public static class Anomaly {
        private boolean detected;
        private String details;
        private String possibleCauses;
    }

    @Data
    public static class Optimization {
        private String suggestion;
        private String action;
    }
}