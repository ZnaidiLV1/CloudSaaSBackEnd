package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AICpuRamAnalysisService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AICpuRamScheduler {
    private final AICpuRamAnalysisService cpuRamAnalysisService;

    @Scheduled(cron = "0 0 12 1 * *")
    public void runMonthlyCpuRamAnalysis() {
        log.info("Starting monthly CPU/RAM analysis for all VMs");
        try {
            cpuRamAnalysisService.analyzeAllVmsCpuRam();
            log.info("Monthly CPU/RAM analysis completed successfully");
        } catch (Exception e) {
            log.error("Monthly CPU/RAM analysis failed: {}", e.getMessage());
        }
    }
}