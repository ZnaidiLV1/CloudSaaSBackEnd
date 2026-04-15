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
    private final CostScheduler costScheduler;
    private final InvoiceScheduler invoiceScheduler;
    private final InfraScheduler infraScheduler;
    private final AlertScheduler alertScheduler;
    private final MonthlyCostScheduler monthlyCostScheduler;
    private final SchedulerConfig schedulerConfig;

    public String updateSchedule(String task, String cronExpression) {
        log.info("Updating schedule for task: {} with cron: {}", task, cronExpression);

        schedulerConfig.updateCronAndSave(task.toLowerCase(), cronExpression);

        switch (task.toLowerCase()) {
            case "performance":
                performanceScheduler.updateSchedule(cronExpression);
                break;
            case "cost":
                costScheduler.updateSchedule(cronExpression);
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
            default:
                return "Unknown task: " + task + ". Available tasks: performance, cost, invoice, infra, alert, monthlyCost";
        }

        return "Successfully updated " + task + " schedule to: " + cronExpression;
    }

    public Map<String, Map<String, Object>> getAllSchedules() {
        return schedulerConfig.getAllSchedulesWithStatus();
    }
}