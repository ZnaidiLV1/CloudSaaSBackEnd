package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
public class CostByMeterDTO {
    private String meterName;
    private String serviceName;
    private BigDecimal cost;

}