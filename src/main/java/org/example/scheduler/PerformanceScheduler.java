package org.example.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.PerformanceService;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class PerformanceScheduler {

    private final PerformanceService performanceService;

//    @Scheduled(fixedRate = 3_600_000)
    public void pullPerformanceMetrics() {
        log.info("PerformanceScheduler — syncing hourly metrics...");
        performanceService.syncMetricsFromAzure();
    }

}