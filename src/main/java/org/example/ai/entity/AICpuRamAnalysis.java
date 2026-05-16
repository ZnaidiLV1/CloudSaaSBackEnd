package org.example.ai.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_cpu_ram_analysis")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AICpuRamAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vm_id", nullable = false)
    private Long vmId;

    @Column(name = "vm_name")
    private String vmName;

    @Column(name = "cpu_has_pattern")
    private Boolean cpuHasPattern;

    @Column(name = "cpu_pattern_description", columnDefinition = "TEXT")
    private String cpuPatternDescription;

    @Column(name = "cpu_peak_day")
    private String cpuPeakDay;

    @Column(name = "cpu_peak_hour")
    private Integer cpuPeakHour;

    @Column(name = "cpu_severity")
    private String cpuSeverity;

    @Column(name = "ram_has_pattern")
    private Boolean ramHasPattern;

    @Column(name = "ram_pattern_description", columnDefinition = "TEXT")
    private String ramPatternDescription;

    @Column(name = "ram_severity")
    private String ramSeverity;

    @Column(name = "anomaly_detected")
    private Boolean anomalyDetected;

    @Column(name = "anomaly_details", columnDefinition = "TEXT")
    private String anomalyDetails;

    @Column(name = "recommendation_action")
    private String recommendationAction;

    @Column(name = "recommendation_suggestion", columnDefinition = "TEXT")
    private String recommendationSuggestion;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}