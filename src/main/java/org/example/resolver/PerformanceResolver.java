package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.performanceDto.*;
import org.example.service.PerformanceService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Slf4j
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

    @QueryMapping
    public VmDailyCpuResponse getVmDailyCpu(
            @Argument Long vmId,
            @Argument String date
    ) {
        return performanceService.getVmDailyCpu(vmId, date);
    }

    @QueryMapping
    public VmDailyRamResponse getVmDailyRam(
            @Argument Long vmId,
            @Argument String date
    ) {
        return performanceService.getVmDailyRam(vmId, date);
    }

    @QueryMapping
    public VmDailyAvailableRamResponse getVmDailyAvailableRam(
            @Argument Long vmId,
            @Argument String date
    ) {
        return performanceService.getVmDailyAvailableRam(vmId, date);
    }

    @QueryMapping
    public VmMetricTotalResponse getVmMetricTotal(
            @Argument Long vmId,
            @Argument String startDate,
            @Argument String endDate,
            @Argument String metricType
    ) {
        return performanceService.getVmMetricTotal(vmId, startDate, endDate, metricType);
    }
}