package org.example.ai.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_cost_analysis")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AICostAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

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

    @Column(name = "main_driver_service")
    private String mainDriverService;

    @Column(name = "service_breakdown_json", columnDefinition = "TEXT")
    private String serviceBreakdownJson;

    @Column(name = "top_driver")
    private String topDriver;

    @Column(name = "fastest_growing")
    private String fastestGrowing;

    @Column(name = "anomalies_json", columnDefinition = "TEXT")
    private String anomaliesJson;

    @Column(name = "predicted_next_month")
    private String predictedNextMonth;

    @Column(name = "predicted_total")
    private Double predictedTotal;

    @Column(name = "predicted_change_percent")
    private Double predictedChangePercent;

    @Column(name = "predicted_direction")
    private String predictedDirection;

    @Column(name = "prediction_confidence")
    private String predictionConfidence;

    @Column(name = "recommendation_action")
    private String recommendationAction;

    @Column(name = "recommendation_suggestion", columnDefinition = "TEXT")
    private String recommendationSuggestion;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}