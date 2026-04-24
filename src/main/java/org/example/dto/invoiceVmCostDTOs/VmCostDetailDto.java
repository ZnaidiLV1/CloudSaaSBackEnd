package org.example.dto.invoiceVmCostDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VmCostDetailDto {
    private Long vmId;
    private String vmName;
    private Double directCost;
    private Double reservationCost;
    private Double sharedCost;
    private Double totalCost;
}