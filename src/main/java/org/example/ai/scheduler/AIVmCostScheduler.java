package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AIVmCostAnalysisService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AIVmCostScheduler {
    private final AIVmCostAnalysisService vmCostAnalysisService;

    @Scheduled(cron = "0 0 16 10 * *")
    public void runMonthlyVmCostAnalysis() {
        log.info("Starting monthly VM cost analysis for all VMs");
        try {
            vmCostAnalysisService.analyzeAllVmsCosts();
            log.info("Monthly VM cost analysis completed successfully");
        } catch (Exception e) {
            log.error("Monthly VM cost analysis failed: {}", e.getMessage());
        }
    }
}