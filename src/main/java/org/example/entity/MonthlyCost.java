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
        indexes = {
                @Index(name = "idx_month_year", columnList = "month, year"),
                @Index(name = "idx_vm_id", columnList = "vm_id"),
                @Index(name = "idx_is_shared", columnList = "is_shared"),
                @Index(name = "idx_service_month", columnList = "service_name, month, year")
        })
public class MonthlyCost {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "month", nullable = false)
    private Integer month;

    @Column(name = "year", nullable = false)
    private Integer year;

    @Column(name = "meter_name", nullable = false, length = 500)
    private String meterName;

    @Column(name = "service_name", nullable = false, length = 200)
    private String serviceName;

    @Column(name = "cost", nullable = false, precision = 38, scale = 15)
    private BigDecimal cost;

    @Column(name = "vm_id")
    private Long vmId;

    @Column(name = "is_shared")
    private Boolean isShared;

    @Column(name = "currency", length = 10)
    private String currency;

    @Column(name = "resource_category", length = 50)
    private String resourceCategory;

    @Column(name = "synced_at")
    private LocalDateTime syncedAt;
}