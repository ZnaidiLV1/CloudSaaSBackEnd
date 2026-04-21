package org.example.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "performance_metrics")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PerformanceMetric {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vm_id", nullable = false)
    private Vm vm;

    private Double cpuMax;
    private Double cpuMin;
    private Double cpuAvg;

    private Double ramMax;
    private Double ramMin;
    private Double ramAvg;

    private Double diskRead;
    private Double diskWrite;
    private Double networkIn;
    private Double networkOut;

    private Double availabilityPercent;

    private LocalDateTime savedAt;
}