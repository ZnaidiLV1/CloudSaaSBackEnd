package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AIMonthlyReportService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AIMonthlyReportScheduler {
    private final AIMonthlyReportService monthlyReportService;

    @Scheduled(cron = "0 0 10 1 * *")
    public void runMonthlyReportGeneration() {
        log.info("Starting monthly report generation");
        try {
            //monthlyReportService.generateMonthlyReport();
            log.info("Monthly report generation completed successfully");
        } catch (Exception e) {
            log.error("Monthly report generation failed: {}", e.getMessage());
        }
    }
}