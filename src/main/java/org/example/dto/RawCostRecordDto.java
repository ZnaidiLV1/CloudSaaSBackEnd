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
public class RawCostRecordDto {
    private String resourceId;
    private String meterCategory;
    private String meterSubCategory;
    private String meterName;
    private String resourceLocation;
    private String pricingModel;
    private String benefitName;
    private String serviceName;
    private String serviceTier;
    private BigDecimal cost;
    private String currency;
    private String date;
}