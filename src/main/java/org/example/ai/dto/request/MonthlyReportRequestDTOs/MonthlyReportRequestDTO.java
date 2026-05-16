package org.example.ai.dto.request.MonthlyReportRequestDTOs;

import lombok.Data;
import java.util.List;

@Data
public class MonthlyReportRequestDTO {
    private Integer reportMonth;
    private Integer reportYear;
    private FinancialData financial;
    private InventoryData inventory;
    private AlertsData alerts;
    private List<AiAlertAnalysisData> aiAlertAnalyses;
    private List<PerformanceData> performance;
    private List<BackupData> backup;
    private List<VmCostData> vmCosts;
    private List<AiVmCostAnalysisData> aiVmCostAnalyses;

    @Data
    public static class FinancialData {
        private Double lastMonthTotal;
        private Double previousMonthTotal;
    }

    @Data
    public static class InventoryData {
        private Integer totalVMs;
        private List<BillingTypeCount> billingTypes;
    }

    @Data
    public static class BillingTypeCount {
        private String type;
        private Integer count;
    }

    @Data
    public static class AlertsData {
        private Integer totalAlerts;
        private List<AlertTypeCount> alertsByType;
        private List<AlertByVm> alertsByVM;
    }

    @Data
    public static class AlertTypeCount {
        private String alertName;
        private Integer count;
    }

    @Data
    public static class AlertByVm {
        private Long vmId;
        private String vmName;
        private Integer totalAlerts;
        private List<AlertTypeCount> alertsByType;
    }

    @Data
    public static class AiAlertAnalysisData {
        private Long vmId;
        private String vmName;
        private Boolean hasPattern;
        private String patternDescription;
        private String suggestionAction;
    }

    @Data
    public static class PerformanceData {
        private Long vmId;
        private String vmName;
        private Double avgCpu;
        private Double maxCpu;
        private String maxCpuDate;
        private Double avgRam;
        private Double maxUsedRam;
        private String maxUsedRamDate;
    }

    @Data
    public static class BackupData {
        private Long vmId;
        private String vmName;
        private Integer successRate;
        private Integer totalBackups;
        private Integer failedBackups;
    }

    @Data
    public static class VmCostData {
        private Long vmId;
        private String vmName;
        private Double directCost;
        private Double reservationCost;
        private Double sharedCost;
        private Double totalCost;
    }

    @Data
    public static class AiVmCostAnalysisData {
        private Long vmId;
        private String vmName;
        private String trend;
        private Double monthOverMonthChange;
        private String recommendationAction;
    }
}