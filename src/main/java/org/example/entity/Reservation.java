package org.example.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "reservations")
public class Reservation {

    @Id
    private String reservationId;

    @Column(nullable = false)
    private String vmType;

    @Column(nullable = false)
    private String displayName;

    @Column(nullable = false)
    private OffsetDateTime purchaseDateTime;

    @Column(nullable = false)
    private OffsetDateTime expiryDateTime;

    @Column(nullable = false)
    private LocalDateTime syncedAt;
}