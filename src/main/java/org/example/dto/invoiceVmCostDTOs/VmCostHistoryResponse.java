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
public class VmCostHistoryResponse {
    private List<VmCostHistory> vmCostHistory;
    private int index;
    private boolean hasNext;
    private boolean hasPrevious;
    private List<String> months;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VmCostHistory {
        private Long vmId;
        private String vmName;
        private List<Double> costs;

    }
}