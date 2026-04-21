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
public class VmDailyAvailableRamResponse {
    private Long vmId;
    private String vmName;
    private String date;
    private List<HourlyAvailableRamValue> hourlyAvailableRam;
}