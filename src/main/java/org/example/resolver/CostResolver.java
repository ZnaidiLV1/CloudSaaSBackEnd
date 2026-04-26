package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.costDTOs.ServiceCostsResponse;
import org.example.dto.invoiceVmCostDTOs.CostByMeterDto;
import org.example.dto.invoiceVmCostDTOs.CostByServiceDto;
import org.example.dto.invoiceVmCostDTOs.SharedCostsResponse;
import org.example.service.MonthlyCostGetGrouped;
import org.example.service.MonthlyCostSyncService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@RequiredArgsConstructor
@Controller
@Slf4j
public class CostResolver {

    private final MonthlyCostGetGrouped monthlyCostGetGrouped;
    private final MonthlyCostSyncService monthlyCostSyncService;

    @MutationMapping
    public String syncMonthlyCosts(@Argument Integer year, @Argument Integer month) {
        log.info("GraphQL mutation: syncMonthlyCosts for {}-{}", year, month);
        return monthlyCostSyncService.syncMonthlyCostsFromAzure(year, month);
    }

    @QueryMapping
    public List<CostByServiceDto> getTotalCostsByService(@Argument int year, @Argument int month) {
        log.info("GraphQL query: getTotalCostsByService for {}-{}", year, month);
        return monthlyCostGetGrouped.getTotalCostsByService(year, month);
    }

    @QueryMapping
    public List<CostByMeterDto> getTotalCostsByMeter(@Argument int year, @Argument int month) {
        log.info("GraphQL query: getTotalCostsByMeter for {}-{}", year, month);
        return monthlyCostGetGrouped.getTotalCostsByMeter(year, month);
    }

    @QueryMapping
    public SharedCostsResponse getSharedCostsByService(@Argument int year, @Argument int month) {
        log.info("GraphQL query: getSharedCostsByService for {}-{}", year, month);
        return monthlyCostGetGrouped.getSharedCostsByService(year, month);
    }

    @QueryMapping
    public ServiceCostsResponse getCostsByServiceName(
            @Argument String startDate,
            @Argument String endDate,
            @Argument String serviceName
    ) {
        log.info("GraphQL query: getCostsByServiceName - startDate: {}, endDate: {}, serviceName: {}", startDate, endDate, serviceName);
        return monthlyCostGetGrouped.getCostsByServiceName(startDate, endDate, serviceName);
    }
}