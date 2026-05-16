package org.example.ai.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_alert_analysis")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIAlertAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vm_id", nullable = false)
    private Long vmId;

    @Column(name = "vm_name")
    private String vmName;

    @Column(name = "alert_has_pattern")
    private Boolean alertHasPattern;

    @Column(name = "alert_pattern_description", columnDefinition = "TEXT")
    private String alertPatternDescription;

    @Column(name = "frequency_per_day")
    private String frequencyPerDay;

    @Column(name = "average_duration_minutes")
    private Integer averageDurationMinutes;

    @Column(name = "peak_hour")
    private Integer peakHour;

    @Column(name = "peak_day")
    private String peakDay;

    @Column(name = "prediction_next_alert")
    private String predictionNextAlert;

    @Column(name = "prediction_trend")
    private String predictionTrend;

    @Column(name = "anomaly_detected")
    private Boolean anomalyDetected;

    @Column(name = "anomaly_details", columnDefinition = "TEXT")
    private String anomalyDetails;

    @Column(name = "suggestion_action")
    private String suggestionAction;

    @Column(name = "suggestion_text", columnDefinition = "TEXT")
    private String suggestionText;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}