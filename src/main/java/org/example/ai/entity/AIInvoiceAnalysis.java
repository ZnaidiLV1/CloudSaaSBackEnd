package org.example.ai.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_invoice_analysis")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIInvoiceAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "TEXT")
    private String summary;

    @Column(name = "year_2024_to_2025_change")
    private Double year2024To2025Change;

    @Column(name = "projected_2026_total")
    private Double projected2026Total;

    @Column(name = "year_2025_to_2026_projected_change")
    private Double year2025To2026ProjectedChange;

    @Column(name = "last_two_months_analysis", columnDefinition = "TEXT")
    private String lastTwoMonthsAnalysis;

    @Column(name = "peak_month_name")
    private String peakMonthName;

    @Column(name = "lowest_month_name")
    private String lowestMonthName;

    @Column(name = "average_monthly_cost")
    private Double averageMonthlyCost;

    @Column(name = "seasonality", columnDefinition = "TEXT")
    private String seasonality;

    @Column(name = "prediction_analysis", columnDefinition = "TEXT")
    private String predictionAnalysis;

    @Column(name = "anomalies_detected")
    private Boolean anomaliesDetected;

    @Column(name = "anomalies_details", columnDefinition = "TEXT")
    private String anomaliesDetails;

    @Column(name = "recommendation_action")
    private String recommendationAction;

    @Column(name = "recommendation_suggestion", columnDefinition = "TEXT")
    private String recommendationSuggestion;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}