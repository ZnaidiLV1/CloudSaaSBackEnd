package org.example.dto.invoiceVmCostDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CostByServiceDto {
    private String serviceName;
    private Double totalCost;
}