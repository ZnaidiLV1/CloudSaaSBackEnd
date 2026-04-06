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
@Table(name = "monthly_vm_costs",
        uniqueConstraints = @UniqueConstraint(columnNames = {"vm_id", "month", "year"}))
public class MonthlyVmCost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vm_id", nullable = false)
    private Vm vm;

    @Column(nullable = false)
    private Integer month;

    @Column(nullable = false)
    private Integer year;

    @Column(nullable = false, precision = 38, scale = 15)
    private BigDecimal directCost;

    @Column(nullable = false, precision = 38, scale = 15)
    private BigDecimal reservationCost;

    @Column(nullable = false, precision = 38, scale = 15)
    private BigDecimal sharedCost;

    @Column(nullable = false, precision = 38, scale = 15)
    private BigDecimal totalCost;

    private Double availabilityPercent;

    private LocalDateTime calculatedAt;
}