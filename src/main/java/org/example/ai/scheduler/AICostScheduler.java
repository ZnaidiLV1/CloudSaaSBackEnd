package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AICostAnalysisService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AICostScheduler {
    private final AICostAnalysisService costAnalysisService;

    @Scheduled(cron = "0 0 15 12 * *")
    public void runMonthlyCostAnalysis() {
        log.info("Starting monthly cost analysis");
        try {
            costAnalysisService.analyzeCosts();
            log.info("Monthly cost analysis completed successfully");
        } catch (Exception e) {
            log.error("Monthly cost analysis failed: {}", e.getMessage());
        }
    }
}