package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AIMonthlyReportService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AIMonthlyReportScheduler {
    private final AIMonthlyReportService monthlyReportService;

    @Scheduled(cron = "0 0 10 12 * *")
    public void runMonthlyReportGeneration() {
        log.info("Starting monthly report generation");
        try {
            LocalDate today = LocalDate.now();
            LocalDate previousMonth = today.minusMonths(1);
            int year = previousMonth.getYear();
            int month = previousMonth.getMonthValue();

            log.info("Generating report for {}-{}", year, month);
            monthlyReportService.generateMonthlyReport(year, month);
            log.info("Monthly report generation completed successfully for {}-{}", year, month);
        } catch (Exception e) {
            log.error("Monthly report generation failed: {}", e.getMessage());
        }
    }
}