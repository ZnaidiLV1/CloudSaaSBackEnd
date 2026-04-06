package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.RawCostRecordDto;
import org.example.service.AzureCostService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class CostRawResolver {

    private final AzureCostService azureCostService;

    @QueryMapping
    public List<RawCostRecordDto> getAllRawCostsForDate(
            @Argument String date
    ) {
        log.info("Fetching ALL raw costs (including empty resourceId) for date: {}", date);
        if (date == null || date.isEmpty()) {
            log.warn("Date parameter is null or empty");
            return List.of();
        }
        LocalDate localDate = LocalDate.parse(date);
        return azureCostService.getAllRawCostsForDate(localDate);
    }

    @QueryMapping
    public List<RawCostRecordDto> getAllRawCostsForDateRange(
            @Argument String startDate,
            @Argument String endDate
    ) {
        log.info("Fetching ALL raw costs (including empty resourceId) from {} to {}", startDate, endDate);
        if (startDate == null || endDate == null || startDate.isEmpty() || endDate.isEmpty()) {
            log.warn("Date range parameters are null or empty");
            return List.of();
        }
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);
        return azureCostService.getAllRawCostsForDateRange(start, end);
    }
}