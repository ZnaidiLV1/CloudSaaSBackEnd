package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.entity.AIMonthlyReport;
import org.example.ai.service.AIMonthlyReportService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AIMonthlyReportResolver {
    private final AIMonthlyReportService monthlyReportService;

    @QueryMapping
    public AIMonthlyReport getMonthlyReportByMonthAndYear(@Argument Integer year, @Argument Integer month) {
        log.info("Fetching monthly report for {}-{}", year, month);
        return monthlyReportService.getMonthlyReportByMonthAndYear(year, month);
    }

    @MutationMapping
    public String generateMonthlyReport(@Argument Integer year, @Argument Integer month) {
        log.info("Manual trigger: Generating monthly report for {}-{}", year, month);
        monthlyReportService.generateMonthlyReport(year, month);
        return "Monthly report generated successfully for " + year + "-" + month;
    }
}