package org.example.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "azure_alerts",
        uniqueConstraints = @UniqueConstraint(columnNames = {"azure_alert_id", "vm_id"}))
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AzureAlert {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vm_id", nullable = false)
    private Vm vm;

    @Column(name = "azure_alert_id", nullable = false)
    private String azureAlertId;

    private String alertName;
    private String severity;
    private String description;
    private LocalDateTime occurredAt;
    private String monitorCondition;
    private LocalDateTime resolvedAt;
    private LocalDateTime firedAt;
    private String alertRule;
    private Long durationSeconds;
    private String metricName;
    private String metricNamespace;
    private Double metricValue;
    private String operator;
    private Double threshold;
}