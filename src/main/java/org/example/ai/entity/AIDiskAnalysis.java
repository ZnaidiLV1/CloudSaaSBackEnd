package org.example.ai.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_disk_analysis")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIDiskAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vm_id", nullable = false)
    private Long vmId;

    @Column(name = "vm_name")
    private String vmName;

    @Column(name = "days_until_full")
    private Integer daysUntilFull;

    @Column(name = "risk_level")
    private String riskLevel;

    @Column(name = "prediction_recommendation", columnDefinition = "TEXT")
    private String predictionRecommendation;

    @Column(name = "anomaly_detected")
    private Boolean anomalyDetected;

    @Column(name = "anomaly_details", columnDefinition = "TEXT")
    private String anomalyDetails;

    @Column(name = "anomaly_possible_causes", columnDefinition = "TEXT")
    private String anomalyPossibleCauses;

    @Column(name = "optimization_suggestion", columnDefinition = "TEXT")
    private String optimizationSuggestion;

    @Column(name = "optimization_action")
    private String optimizationAction;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}