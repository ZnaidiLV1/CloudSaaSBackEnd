package org.example.azure.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.azure.service.TroubleshootService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class TroubleshootScheduler {

    private final TroubleshootService troubleshootService;

    @Scheduled(cron = "0 13 * * * *")
    public void runEveryHourAtMinute30() {
        log.info("Starting scheduled troubleshoot data fetch at {}", java.time.LocalDateTime.now());
        try {
            String result = troubleshootService.fetchAndSaveLatestHealth();
            log.info("Scheduled troubleshoot data fetch completed: {}", result);
        } catch (Exception e) {
            log.error("Scheduled troubleshoot data fetch failed: {}", e.getMessage());
        }
    }
}