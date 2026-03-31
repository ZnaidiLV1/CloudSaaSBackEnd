package org.example.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.CostService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class CostScheduler {

    private final CostService costService;

    @Scheduled(cron = "0 0 1 * * *")
    public void pullDailyCosts() {
        log.info("CostScheduler — pulling daily costs from Azure...");
        costService.syncDailyCostsFromAzure();
    }
}