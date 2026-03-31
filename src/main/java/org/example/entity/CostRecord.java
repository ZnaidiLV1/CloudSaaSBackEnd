package org.example.entity;

import jakarta.persistence.*;
import lombok.*;
import org.example.enums.CostType;
import java.time.LocalDate;

@Entity
@Table(name = "cost_records")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CostRecord {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vm_id", nullable = false)
    private Vm vm;

    @Enumerated(EnumType.STRING)
    private CostType costType;

    private Double amount;
    private String currency;
    private LocalDate date;
}