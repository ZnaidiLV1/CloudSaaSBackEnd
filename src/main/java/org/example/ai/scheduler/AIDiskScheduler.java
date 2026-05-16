package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AIDiskAnalysisService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AIDiskScheduler {

    private final AIDiskAnalysisService diskAnalysisService;

    @Scheduled(cron = "0 0 11 1 * *")
    public void runMonthlyDiskAnalysis() {
        log.info("Starting monthly disk analysis for all VMs");
        try {
            diskAnalysisService.analyzeAllVms();
            log.info("Monthly disk analysis completed successfully");
        } catch (Exception e) {
            log.error("Monthly disk analysis failed: {}", e.getMessage());
        }
    }
}