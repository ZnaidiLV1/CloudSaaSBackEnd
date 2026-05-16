package org.example.ai.dto.response.VmCostResponseDTOs;

import lombok.Data;
import java.util.List;

@Data
public class VmCostAnalysisResponseDTO {
    private List<VmAnalysis> analyses;
    private String overallSummary;

    @Data
    public static class VmAnalysis {
        private Long vmId;
        private String vmName;
        private String summary;
        private MonthlyComparison monthlyComparison;
        private Statistics statistics;
        private CostEfficiency costEfficiency;
        private Prediction prediction;
        private Recommendation recommendation;
    }

    @Data
    public static class MonthlyComparison {
        private String previousMonth;
        private String currentMonth;
        private Double changePercent;
        private String direction;
        private String cause;
    }

    @Data
    public static class Statistics {
        private Double averageMonthly;
        private String peakMonth;
        private String lowestMonth;
        private String trend;
        private Integer reservationUtilization;
    }

    @Data
    public static class CostEfficiency {
        private Double reservationSavingsPercent;
        private Double sharedCostPercentOfTotal;
        private String recommendedAction;
    }

    @Data
    public static class Prediction {
        private String nextMonth;
        private Double predictedTotal;
        private Double predictedDirect;
        private Double predictedReservation;
        private Double predictedShared;
        private Double changePercent;
        private String direction;
        private String confidence;
        private String explanation;
    }

    @Data
    public static class Recommendation {
        private String action;
        private String suggestion;
    }
}