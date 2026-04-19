package org.example.resolver;

import lombok.RequiredArgsConstructor;
import org.example.dto.performanceDto.VmAvailableRamResponse;
import org.example.dto.performanceDto.VmPerformanceResponse;
import org.example.dto.performanceDto.VmPerformanceSummary;
import org.example.service.PerformanceService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class PerformanceResolver {

    private final PerformanceService performanceService;

    @QueryMapping
    public VmPerformanceResponse getVmPerformance(
            @Argument Long vmId,
            @Argument String startDate,
            @Argument String endDate
    ) {
        return performanceService.getVmPerformance(vmId, startDate, endDate);
    }

    @QueryMapping
    public VmPerformanceSummary getVmPerformanceSummary(
            @Argument Long vmId,
            @Argument String startDate,
            @Argument String endDate
    ) {
        return performanceService.getVmPerformanceSummary(vmId, startDate, endDate);
    }

    @QueryMapping
    public VmAvailableRamResponse getVmAvailableRam(
            @Argument Long vmId,
            @Argument String startDate,
            @Argument String endDate
    ) {
        return performanceService.getVmAvailableRam(vmId, startDate, endDate);
    }
}