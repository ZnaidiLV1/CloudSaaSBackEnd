package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.MonthlyCostSyncService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

@RequiredArgsConstructor
@Controller
@Slf4j
public class CostResolver {

    private final MonthlyCostSyncService monthlyCostSyncService;

    @MutationMapping
    public String syncMonthlyCosts(@Argument Integer year, @Argument Integer month) {
        log.info("GraphQL mutation: syncMonthlyCosts for {}-{}", year, month);
        return monthlyCostSyncService.syncMonthlyCostsFromAzure(year, month);
    }
}