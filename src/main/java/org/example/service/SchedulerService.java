package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.config.SchedulerConfig;
import org.example.scheduler.*;
import org.springframework.stereotype.Service;

import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class SchedulerService {

    private final PerformanceScheduler performanceScheduler;
    private final InvoiceScheduler invoiceScheduler;
    private final InfraScheduler infraScheduler;
    private final AlertScheduler alertScheduler;
    private final MonthlyCostScheduler monthlyCostScheduler;
    private final BackupScheduler backupScheduler;
    private final SchedulerConfig schedulerConfig;

    public String updateSchedule(String task, String cronExpression) {
        log.info("Updating schedule for task: {} with cron: {}", task, cronExpression);

        schedulerConfig.updateCronAndSave(task, cronExpression);

        String taskLower = task.toLowerCase();
        switch (taskLower) {
            case "performance":
                performanceScheduler.updateSchedule(cronExpression);
                break;
            case "invoice":
                invoiceScheduler.updateSchedule(cronExpression);
                break;
            case "infra":
                infraScheduler.updateSchedule(cronExpression);
                break;
            case "alert":
                alertScheduler.updateSchedule(cronExpression);
                break;
            case "monthlycost":
                monthlyCostScheduler.updateSchedule(cronExpression);
                break;
            case "backup":
                backupScheduler.updateSchedule(cronExpression);
                break;
            default:
                return "Unknown task: " + task + ". Available tasks: performance, invoice, infra, alert, monthlyCost, backup";
        }

        return "Successfully updated " + task + " schedule to: " + cronExpression;
    }

    public Map<String, Map<String, Object>> getAllSchedules() {
        return schedulerConfig.getAllSchedulesWithStatus();
    }
}