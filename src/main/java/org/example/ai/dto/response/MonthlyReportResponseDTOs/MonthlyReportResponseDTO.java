package org.example.ai.dto.response.MonthlyReportResponseDTOs;

import lombok.Data;
import java.util.List;

@Data
public class MonthlyReportResponseDTO {
    private Integer reportMonth;
    private Integer reportYear;
    private Double lastMonthInvoiceValue;
    private Integer invoicePercentChange;
    private Integer totalVMs;
    private List<BillingTypeCount> billingTypes;
    private Integer totalAlerts;
    private List<AlertTypeCount> alertsByType;
    private List<AlertByVmResponse> alertsByVM;
    private String aiAlertAnalysis;
    private String aiAlertRecommendation;
    private List<PerformanceDataResponse> performanceData;
    private String aiPerformanceAnalysis;
    private String aiPerformanceRecommendation;
    private List<BackupDataResponse> backupData;
    private String aiBackupAnalysis;
    private String aiBackupRecommendation;
    private List<FinancialDataResponse> financialData;
    private String aiCostAnalysis;
    private String aiCostRecommendation;
    private String aiInfrastructureSummary;

    @Data
    public static class BillingTypeCount {
        private String type;
        private Integer count;
    }

    @Data
    public static class AlertTypeCount {
        private String alertName;
        private Integer count;
    }

    @Data
    public static class AlertByVmResponse {
        private Long vmId;
        private String vmName;
        private Integer totalAlerts;
        private List<AlertTypeCount> alertsByType;
    }

    @Data
    public static class PerformanceDataResponse {
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
    public static class BackupDataResponse {
        private Long vmId;
        private String vmName;
        private Integer successRate;
        private Integer totalBackups;
        private Integer failedBackups;
    }

    @Data
    public static class FinancialDataResponse {
        private Long vmId;
        private String vmName;
        private String directCost;
        private String reservationCost;
        private String sharedCost;
        private String totalCost;
    }
}