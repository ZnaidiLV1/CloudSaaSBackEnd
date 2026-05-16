package org.example.ai.dto.response.AlertResponseDTOs;

import lombok.Data;
import java.util.List;

@Data
public class AlertAnalysisResponseDTO {
    private List<VmAlertAnalysis> analyses;

    @Data
    public static class VmAlertAnalysis {
        private Long vmId;
        private String vmName;
        private AlertPattern alertPattern;
        private Prediction prediction;
        private Anomaly anomaly;
        private Suggestion suggestion;
    }

    @Data
    public static class AlertPattern {
        private Boolean hasPattern;
        private String description;
        private String frequencyPerDay;
        private Integer averageDurationMinutes;
        private Integer peakHour;
        private String peakDay;
    }

    @Data
    public static class Prediction {
        private String nextExpectedAlert;
        private String trend;
    }

    @Data
    public static class Anomaly {
        private Boolean detected;
        private String details;
    }

    @Data
    public static class Suggestion {
        private String action;
        private String suggestion;
    }
}