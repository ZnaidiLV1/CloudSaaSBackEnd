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
public class SharedCostsResponse {
    private Integer year;
    private Integer month;
    private List<SharedCostByServiceDto> sharedCostsByService;
}