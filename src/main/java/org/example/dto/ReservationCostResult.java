package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ReservationCostResult {
    private String meterName;
    private String serviceName;
    private Double cost;
    private String resourceId;
    private String pricingModel;
    private String benefitName;
}