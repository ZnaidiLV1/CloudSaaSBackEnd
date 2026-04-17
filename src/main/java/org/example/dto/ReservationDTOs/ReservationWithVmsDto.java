package org.example.dto.ReservationDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReservationWithVmsDto {
    private String displayName;
    private String vmType;
    private OffsetDateTime purchaseDateTime;
    private OffsetDateTime expiryDateTime;
    private List<LinkedVmDto> linkedVms;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class LinkedVmDto {
        private String vmName;
    }
}