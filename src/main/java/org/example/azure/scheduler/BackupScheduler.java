package org.example.azure.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.azure.config.SchedulerConfig;
import org.example.azure.service.BackupService;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.concurrent.ScheduledFuture;

@Component
@Slf4j
@RequiredArgsConstructor
public class BackupScheduler {

    private final BackupService backupService;
    private final TaskScheduler taskScheduler;
    private final SchedulerConfig schedulerConfig;
    private ScheduledFuture<?> scheduledTask;

    public void initialize() {
        String cron = schedulerConfig.getCronForTask("backup");
        log.info("Initializing BackupScheduler with cron: {}", cron);
        scheduleTask(cron);
    }

    public void executeTask() {
        long startTime = System.currentTimeMillis();
        log.info("BackupScheduler — syncing backup data...");

        schedulerConfig.updateStatusOnly("backup", "RUNNING");

        try {
            backupService.syncAllBackupData();
            long duration = System.currentTimeMillis() - startTime;
            schedulerConfig.updateExecutionStatus("backup", LocalDateTime.now(), "SUCCESS");
            log.info("BackupScheduler — completed successfully in {} ms", duration);
        } catch (Exception e) {
            log.error("BackupScheduler — failed: {}", e.getMessage());
            schedulerConfig.updateStatusOnly("backup", "FAILED");
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