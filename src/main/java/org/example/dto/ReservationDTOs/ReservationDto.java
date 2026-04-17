package org.example.dto.ReservationDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.OffsetDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationDto {
    private String reservationId;
    private String reservationOrderId;
    private String displayName;
    private String vmType;           // e.g., "D2ls v5"
    private String term;             // e.g., "P1Y" (1 year), "P3Y" (3 years)
    private String provisioningState; // e.g., "Succeeded"
    private OffsetDateTime expiryDateTime;
    private OffsetDateTime purchaseDateTime;
}