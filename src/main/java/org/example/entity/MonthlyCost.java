package org.example.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "monthly_costs",
        uniqueConstraints = @UniqueConstraint(columnNames = {"month", "year", "meter_name", "service_name"}))
public class MonthlyCost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "month", nullable = false)
    private Integer month;

    @Column(name = "year", nullable = false)
    private Integer year;

    @Column(name = "meter_name", nullable = false)
    private String meterName;

    @Column(name = "service_name", nullable = false)
    private String serviceName;

    @Column(name = "cost", nullable = false, precision = 15, scale = 2)
    private BigDecimal cost;

    @Column(name = "synced_at")
    private LocalDateTime syncedAt;



}