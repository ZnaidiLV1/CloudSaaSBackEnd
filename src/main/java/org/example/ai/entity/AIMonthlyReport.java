package org.example.ai.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_monthly_report")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIMonthlyReport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "report_month")
    private Integer reportMonth;

    @Column(name = "report_year")
    private Integer reportYear;

    @Column(name = "last_month_invoice_value")
    private Double lastMonthInvoiceValue;

    @Column(name = "invoice_percent_change")
    private Integer invoicePercentChange;

    @Column(name = "total_vms")
    private Integer totalVMs;

    @Column(name = "billing_types", columnDefinition = "TEXT")
    private String billingTypes;

    @Column(name = "total_alerts")
    private Integer totalAlerts;

    @Column(name = "alerts_by_type", columnDefinition = "TEXT")
    private String alertsByType;

    @Column(name = "alerts_by_vm", columnDefinition = "TEXT")
    private String alertsByVM;

    @Column(name = "ai_alert_analysis", columnDefinition = "TEXT")
    private String aiAlertAnalysis;

    @Column(name = "ai_alert_recommendation", columnDefinition = "TEXT")
    private String aiAlertRecommendation;

    @Column(name = "performance_data", columnDefinition = "TEXT")
    private String performanceData;

    @Column(name = "ai_performance_analysis", columnDefinition = "TEXT")
    private String aiPerformanceAnalysis;

    @Column(name = "ai_performance_recommendation", columnDefinition = "TEXT")
    private String aiPerformanceRecommendation;

    @Column(name = "backup_data", columnDefinition = "TEXT")
    private String backupData;

    @Column(name = "ai_backup_analysis", columnDefinition = "TEXT")
    private String aiBackupAnalysis;

    @Column(name = "ai_backup_recommendation", columnDefinition = "TEXT")
    private String aiBackupRecommendation;

    @Column(name = "financial_data", columnDefinition = "TEXT")
    private String financialData;

    @Column(name = "ai_cost_analysis", columnDefinition = "TEXT")
    private String aiCostAnalysis;

    @Column(name = "ai_cost_recommendation", columnDefinition = "TEXT")
    private String aiCostRecommendation;

    @Column(name = "ai_infrastructure_summary", columnDefinition = "TEXT")
    private String aiInfrastructureSummary;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}