package org.example.dto.invoiceVmCostDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CostByMeterDto {
    private String meterName;
    private Double totalCost;
}