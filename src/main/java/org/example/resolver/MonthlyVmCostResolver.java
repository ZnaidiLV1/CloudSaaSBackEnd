package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.invoiceVmCostDTOs.*;
import org.example.service.MonthlyVmCostService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MonthlyVmCostResolver {

    private final MonthlyVmCostService monthlyVmCostService;

    @MutationMapping
    public String calculateMonthlyVmCosts(@Argument Integer year, @Argument Integer month) {
        log.info("GraphQL mutation: calculateMonthlyVmCosts for {}-{}", year, month);
        return monthlyVmCostService.calculateMonthlyVmCosts(year, month);
    }

    @QueryMapping
    public VmCostHistoryResponse getVmCostHistory(@Argument Integer index) {
        log.info("GraphQL Query: getVmCostHistory with index={}", index);
        return monthlyVmCostService.getVmCostHistory(index != null ? index : 0);
    }

    @QueryMapping
    public List<VmCostByMonthDto> getVmCostsByMonthAndYear(
            @Argument Integer year,
            @Argument Integer month) {
        return monthlyVmCostService.getVmCostsByMonthAndYear(year, month);
    }

    @QueryMapping
    public VmCostDetailDto getVmCostDetail(
            @Argument Long vmId,
            @Argument Integer year,
            @Argument Integer month
    ) {
        log.info("GraphQL Query: getVmCostDetail for VM: {}, year: {}, month: {}", vmId, year, month);
        return monthlyVmCostService.getVmCostDetail(vmId, year, month);
    }

    @QueryMapping
    public List<VmCostByServiceDto> getVmCostsByServiceForVm(
            @Argument Long vmId,
            @Argument Integer year,
            @Argument Integer month
    ) {
        return monthlyVmCostService.getVmCostsByServiceForVm(vmId, year, month);
    }

    @QueryMapping
    public VmCostHistoryDto getVmCostHistoryByDateRange(
            @Argument Long vmId,
            @Argument String startDate,
            @Argument String endDate
    ) {
        return monthlyVmCostService.getVmCostHistoryByDateRange(vmId, startDate, endDate);
    }

}