package org.example.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.AlertService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class AlertScheduler {

    private final AlertService alertService;

    //@Scheduled(fixedRate = 7_200_000)
    public void syncAlerts() {
        log.info("AlertScheduler — syncing last 2h alerts from Azure...");
        alertService.syncAlertsFromAzure();
    }
}