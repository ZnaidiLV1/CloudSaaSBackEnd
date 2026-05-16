package org.example.ai.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_vm_cost_analysis")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIVmCostAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vm_id", nullable = false)
    private Long vmId;

    @Column(name = "vm_name")
    private String vmName;

    @Column(columnDefinition = "TEXT")
    private String summary;

    @Column(name = "previous_month")
    private String previousMonth;

    @Column(name = "previous_month_total")
    private Double previousMonthTotal;

    @Column(name = "current_month")
    private String currentMonth;

    @Column(name = "current_month_total")
    private Double currentMonthTotal;

    @Column(name = "month_over_month_change")
    private Double monthOverMonthChange;

    @Column(name = "month_over_month_direction")
    private String monthOverMonthDirection;

    @Column(name = "change_cause", columnDefinition = "TEXT")
    private String changeCause;

    @Column(name = "average_monthly")
    private Double averageMonthly;

    @Column(name = "peak_month")
    private String peakMonth;

    @Column(name = "lowest_month")
    private String lowestMonth;

    @Column(name = "trend")
    private String trend;

    @Column(name = "reservation_utilization")
    private Integer reservationUtilization;

    @Column(name = "reservation_savings_percent")
    private Double reservationSavingsPercent;

    @Column(name = "shared_cost_percent")
    private Double sharedCostPercent;

    @Column(name = "cost_efficiency_action")
    private String costEfficiencyAction;

    @Column(name = "predicted_next_month")
    private String predictedNextMonth;

    @Column(name = "predicted_total")
    private Double predictedTotal;

    @Column(name = "predicted_direct")
    private Double predictedDirect;

    @Column(name = "predicted_reservation")
    private Double predictedReservation;

    @Column(name = "predicted_shared")
    private Double predictedShared;

    @Column(name = "predicted_change_percent")
    private Double predictedChangePercent;

    @Column(name = "predicted_direction")
    private String predictedDirection;

    @Column(name = "prediction_confidence")
    private String predictionConfidence;

    @Column(name = "prediction_explanation", columnDefinition = "TEXT")
    private String predictionExplanation;

    @Column(name = "recommendation_action")
    private String recommendationAction;

    @Column(name = "recommendation_suggestion", columnDefinition = "TEXT")
    private String recommendationSuggestion;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}