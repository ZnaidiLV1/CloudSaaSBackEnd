package org.example.ai.dto.response.InvoiceResponseDTOs;

import lombok.Data;
import java.util.List;

@Data
public class InvoiceAnalysisResponseDTO {
    private Analysis analysis;

    @Data
    public static class Analysis {
        private String summary;
        private YearlyComparison yearlyComparison;
        private String lastTwoMonthsAnalysis;
        private MonthlyInsights monthlyInsights;
        private String predictionAnalysis;
        private List<String> anomalies;
        private Recommendation recommendation;
    }

    @Data
    public static class YearlyComparison {
        private Double change2024to2025;
        private Double projected2026;
        private Double change2025to2026;
    }

    @Data
    public static class MonthlyInsights {
        private String peakMonth;
        private String lowestMonth;
        private Double averageMonthly;
        private String seasonality;
    }

    @Data
    public static class Recommendation {
        private String action;
        private String suggestion;
    }
}