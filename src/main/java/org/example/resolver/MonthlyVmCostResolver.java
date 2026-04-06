package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.MonthlyVmCostService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

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
}