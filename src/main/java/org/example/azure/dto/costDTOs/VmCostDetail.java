package org.example.azure.dto.costDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VmCostDetail {
    private Long vmId;
    private String vmName;
    private Double totalAmount;
}
