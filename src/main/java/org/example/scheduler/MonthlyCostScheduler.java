package org.example.scheduler;

import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.config.SchedulerConfig;
import org.example.service.MonthlyCostSyncService;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.concurrent.ScheduledFuture;

@Component
@Slf4j
@RequiredArgsConstructor
public class MonthlyCostScheduler {

    private final MonthlyCostSyncService monthlyCostSyncService;
    private final TaskScheduler taskScheduler;
    private final SchedulerConfig schedulerConfig;
    private ScheduledFuture<?> scheduledTask;

  public void initialize() {
        String cron = schedulerConfig.getCronForTask("monthlyCost");
        log.info("Initializing MonthlyCostScheduler with cron: {}", cron);
        scheduleTask(cron);
    }

    public void executeTask() {
        LocalDate now = LocalDate.now();
        LocalDate lastMonth = now.minusMonths(1);
        int year = lastMonth.getYear();
        int month = lastMonth.getMonthValue();
        monthlyCostSyncService.syncMonthlyCostsFromAzure(year, month);
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
        schedulerConfig.updateCronAndSave("monthlyCost", newCron);
        scheduleTask(newCron);
    }
}