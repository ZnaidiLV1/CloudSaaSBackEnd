package org.example.dto.performanceDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VmPerformanceResponse {
    private Long vmId;
    private String vmName;
    private String vmType;
    private List<DailyPerformance> dailyPerformances;
}