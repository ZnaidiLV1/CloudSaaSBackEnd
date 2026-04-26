package org.example.dto.costDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ServiceCostsResponse {
    private List<String> serviceNames;
    private List<String> months;
    private List<ServiceCostData> services;
}