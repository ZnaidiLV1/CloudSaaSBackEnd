package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
@AllArgsConstructor
public class CostByServiceDTO {
    private String serviceName;
    private BigDecimal totalCost;
    private List<CostByMeterDTO> meters;

}