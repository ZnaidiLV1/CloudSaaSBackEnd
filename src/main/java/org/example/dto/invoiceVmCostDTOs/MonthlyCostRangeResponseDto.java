package org.example.dto.invoiceVmCostDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MonthlyCostRangeResponseDto {
    private Boolean isAllVms;
    private List<String> months;
    private List<VmMonthlyCostData> vmCosts;
    private Long vmId;
    private String vmName;
    private List<Double> costs;
}