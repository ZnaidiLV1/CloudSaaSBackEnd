package org.example.azure.dto.performanceDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class HourlyMetricsValue {
    private String hour;
    private Double networkIn;
    private Double networkOut;
    private Double diskRead;
    private Double diskWrite;
}
