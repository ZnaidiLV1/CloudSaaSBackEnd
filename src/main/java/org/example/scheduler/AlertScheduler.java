package org.example.scheduler;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.config.SchedulerConfig;
import org.example.service.AlertService;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.concurrent.ScheduledFuture;

@Component
@Slf4j
@RequiredArgsConstructor
public class AlertScheduler {

    private final AlertService alertService;
    private final TaskScheduler taskScheduler;
    private final SchedulerConfig schedulerConfig;
    private ScheduledFuture<?> scheduledTask;

    public void initialize() {
        String cron = schedulerConfig.getCronForTask("alert");
        log.info("Initializing AlertScheduler with cron: {}", cron);
        scheduleTask(cron);
    }
    public void executeTask() {
        long startTime = System.currentTimeMillis();
        log.info("AlertScheduler — syncing alerts...");

        schedulerConfig.updateStatusOnly("alert", "RUNNING");

        try {
            alertService.syncLastDayAlerts();
            long duration = System.currentTimeMillis() - startTime;
            schedulerConfig.updateExecutionStatus("alert", LocalDateTime.now(), "SUCCESS");
            log.info("AlertScheduler — completed successfully in {} ms", duration);
        } catch (Exception e) {
            log.error("AlertScheduler — failed: {}", e.getMessage());
            schedulerConfig.updateStatusOnly("alert", "FAILED");
        }
    }

    public void scheduleTask(String cron) {
        if (cron == null || cron.isEmpty()) {
            log.error("Cannot schedule task with null or empty cron!");
            return;
        }

        if (scheduledTask != null) {
            scheduledTask.cancel(false);
        }
        scheduledTask = taskScheduler.schedule(this::executeTask, new CronTrigger(cron));
        log.info("Task scheduled with cron: {}", cron);
    }

    public void updateSchedule(String newCron) {
        scheduleTask(newCron);
    }
}