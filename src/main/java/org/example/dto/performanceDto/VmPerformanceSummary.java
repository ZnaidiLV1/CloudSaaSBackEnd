package org.example.dto.performanceDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VmPerformanceSummary {
    private Long vmId;
    private String vmName;
    private Double avgMaxCpu;
    private Double avgCpu;
    private Double avgMaxRamPercentage;
    private Double avgRamPercentage;
}