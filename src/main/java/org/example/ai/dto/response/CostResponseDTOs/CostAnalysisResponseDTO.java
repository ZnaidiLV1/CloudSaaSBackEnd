package org.example.ai.dto.response.CostResponseDTOs;

import lombok.Data;
import java.util.List;

@Data
public class CostAnalysisResponseDTO {
    private Analysis analysis;

    @Data
    public static class Analysis {
        private String summary;
        private MonthlyComparison monthlyComparison;
        private ServiceBreakdown serviceBreakdown;
        private List<String> anomalies;
        private Prediction prediction;
        private Recommendation recommendation;
    }

    @Data
    public static class MonthlyComparison {
        private String previousMonth;
        private Double previousMonthTotal;
        private String currentMonth;
        private Double currentMonthTotal;
        private Double changePercent;
        private String direction;
        private String mainDriver;
    }

    @Data
    public static class ServiceBreakdown {
        private List<ServiceAverage> averageMonthly;
        private String topDriver;
        private String fastestGrowing;
    }

    @Data
    public static class ServiceAverage {
        private String serviceName;
        private Double averageCost;
        private Double percentageOfTotal;
    }

    @Data
    public static class Prediction {
        private String nextMonth;
        private Double predictedTotal;
        private Double changePercent;
        private String direction;
        private String confidence;
    }

    @Data
    public static class Recommendation {
        private String action;
        private String suggestion;
    }
}