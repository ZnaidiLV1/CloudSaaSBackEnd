package org.example.dto.performanceDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyPerformance {
    private String date;
    private Double maxCpu;
    private String maxCpuTime;
    private Double maxRamPercentage;
    private String maxRamTime;
}