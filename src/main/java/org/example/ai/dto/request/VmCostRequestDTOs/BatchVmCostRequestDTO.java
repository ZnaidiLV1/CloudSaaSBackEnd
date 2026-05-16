package org.example.ai.dto.request.VmCostRequestDTOs;

import lombok.Data;
import java.util.List;

@Data
public class BatchVmCostRequestDTO {
    private List<VmCostData> vms;

    @Data
    public static class VmCostData {
        private Long vmId;
        private String vmName;
        private List<MonthlyCostDetail> months;
    }

    @Data
    public static class MonthlyCostDetail {
        private String month;
        private Double directCost;
        private Double reservationCost;
        private Double sharedCost;
        private Double totalCost;
    }
}