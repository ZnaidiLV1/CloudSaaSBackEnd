package org.example.azure.dto.costDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TotalCostForVmsResponse {
    private Double totalAmount;
    private List<MonthlyBreakdown> breakdown;
    private List<VmCostDetail> vmDetails;
}

