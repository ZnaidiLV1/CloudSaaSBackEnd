package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.AlertsDto.AlertHeatmapResponse;
import org.example.dto.AlertsDto.AlertPageResponse;
import org.example.dto.AlertsDto.AlertSummaryResponse;
import org.example.service.AlertService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AlertResolver {

    private final AlertService alertService;

    @QueryMapping
    public AlertPageResponse alertsByVmId(
            @Argument Long vmId,
            @Argument int index
    ) {
        log.info("GraphQL: alertsByVmId called - vmId: {}, index: {}", vmId, index);
        return alertService.getAlertsByVmId(vmId, index);
    }

    @QueryMapping
    public AlertSummaryResponse alertSummary(
            @Argument Long vmId,
            @Argument String startDate,
            @Argument String endDate
    ) {
        log.info("GraphQL: alertSummary called - vmId: {}, startDate: {}, endDate: {}", vmId, startDate, endDate);
        return alertService.getAlertSummary(vmId, startDate, endDate);
    }
    @QueryMapping
    public AlertHeatmapResponse alertHeatmap(
            @Argument Long vmId
    ) {
        log.info("GraphQL: alertHeatmap called - vmId: {}", vmId);
        return alertService.getAlertHeatmap(vmId);
    }
}