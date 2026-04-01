package org.example.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "invoices", uniqueConstraints = {
        @UniqueConstraint(columnNames = "invoiceId")
})
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String invoiceId;

    private String invoiceName;
    private String status;
    private LocalDateTime invoiceDate;
    private LocalDateTime dueDate;
    private LocalDateTime billingPeriodStart;
    private LocalDateTime billingPeriodEnd;

    private Double totalAmount;
    private Double amountDue;
    private String currency;
    private String downloadUrl;
}