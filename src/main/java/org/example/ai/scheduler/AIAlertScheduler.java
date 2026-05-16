package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AIAlertAnalysisService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AIAlertScheduler {
    private final AIAlertAnalysisService alertAnalysisService;

    @Scheduled(cron = "0 0 13 1 * *")
    public void runMonthlyAlertAnalysis() {
        log.info("Starting monthly alert analysis for all VMs");
        try {
            alertAnalysisService.analyzeAllVmsAlerts();
            log.info("Monthly alert analysis completed successfully");
        } catch (Exception e) {
            log.error("Monthly alert analysis failed: {}", e.getMessage());
        }
    }
}