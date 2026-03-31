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

    // CPU stats (%)
    private Double cpuMax;
    private Double cpuMin;
    private Double cpuAvg;

    // RAM stats (GB)
    private Double ramMax;
    private Double ramMin;
    private Double ramAvg;

    // Disk read (bytes/sec)
    private Double diskMax;
    private Double diskMin;
    private Double diskAvg;

    private Double availabilityPercent;

    private LocalDateTime savedAt;
}