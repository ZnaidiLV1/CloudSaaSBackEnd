package org.example.ai.dto.request.CostRequestDTOs;

import lombok.Data;
import java.util.List;

@Data
public class BatchCostRequestDTO {
    private List<MonthlyCostData> months;

    @Data
    public static class MonthlyCostData {
        private String month;
        private Integer year;
        private Double totalCost;
        private List<ServiceCost> services;
    }

    @Data
    public static class ServiceCost {
        private String serviceName;
        private Double cost;
    }
}