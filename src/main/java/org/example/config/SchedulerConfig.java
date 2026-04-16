package org.example.config;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.SchedulerConfigEntity;
import org.example.repository.SchedulerConfigRepository;
import org.springframework.scheduling.support.CronTrigger;
import org.springframework.scheduling.support.SimpleTriggerContext;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Slf4j
@Component
public class SchedulerConfig {

    private static final Map<String, String> DEFAULTS = Map.of(
            "performance", "0 0 * * * *",
            "cost", "0 0 1 * * *",
            "invoice", "0 0 2 11 * *",
            "infra", "0 0 2 * * *",
            "alert", "0 0 */2 * * *",
            "monthlyCost", "0 0 2 11 * *"
    );

    private final SchedulerConfigRepository repository;
    private final Map<String, SchedulerConfigEntity> currentSchedules = new HashMap<>();

    public SchedulerConfig(SchedulerConfigRepository repository) {
        this.repository = repository;
    }

    @PostConstruct
    public void loadFromDatabase() {
        log.info("Loading scheduler configurations from database...");

        for (String taskName : DEFAULTS.keySet()) {
            SchedulerConfigEntity entity = repository.findById(taskName).orElse(null);

            if (entity == null) {
                entity = new SchedulerConfigEntity(taskName, DEFAULTS.get(taskName), null, "NEVER_RUN");
                repository.save(entity);
                currentSchedules.put(taskName, entity);
                log.info("Initialized {} with default: {}", taskName, DEFAULTS.get(taskName));
            } else {
                if (entity.getLastStatus() == null) {
                    entity.setLastStatus("NEVER_RUN");
                    repository.save(entity);
                }
                currentSchedules.put(taskName, entity);
                log.info("Loaded {} from DB: {}", taskName, entity.getCronExpression());
            }
        }
    }

    public String getCronForTask(String taskName) {
        SchedulerConfigEntity entity = currentSchedules.get(taskName);
        return entity != null ? entity.getCronExpression() : null;
    }

    public Map<String, Object> getScheduleWithStatus(String taskName) {
        SchedulerConfigEntity entity = currentSchedules.get(taskName);
        if (entity == null) return null;

        Map<String, Object> result = new HashMap<>();
        result.put("cronExpression", entity.getCronExpression());
        result.put("lastExecution", entity.getLastExecution());
        String lastStatus = entity.getLastStatus();
        result.put("lastStatus", lastStatus != null ? lastStatus : "NEVER_RUN");
        result.put("nextExecution", calculateNextExecution(entity.getCronExpression()));

        return result;
    }

    public Map<String, Map<String, Object>> getAllSchedulesWithStatus() {
        Map<String, Map<String, Object>> result = new HashMap<>();

        for (String taskName : currentSchedules.keySet()) {
            result.put(taskName, getScheduleWithStatus(taskName));
        }

        return result;
    }

    private LocalDateTime calculateNextExecution(String cronExpression) {
        if (cronExpression == null || cronExpression.isEmpty()) {
            return null;
        }

        try {
            CronTrigger trigger = new CronTrigger(cronExpression);
            SimpleTriggerContext triggerContext = new SimpleTriggerContext();
            triggerContext.update(new Date(), new Date(), new Date());

            Date next = Date.from(Objects.requireNonNull(trigger.nextExecution(triggerContext)));

            return LocalDateTime.ofInstant(next.toInstant(), ZoneId.systemDefault());
        } catch (Exception e) {
            log.error("Failed to calculate next execution for cron: {}", cronExpression, e);
        }

        return null;
    }

    public void updateCronAndSave(String taskName, String cronExpression) {
        SchedulerConfigEntity entity = currentSchedules.get(taskName);
        if (entity != null) {
            entity.setCronExpression(cronExpression);
            repository.save(entity);
            currentSchedules.put(taskName, entity);
            log.info("Updated {} schedule to: {}", taskName, cronExpression);
        }
    }

    public void updateExecutionStatus(String taskName, LocalDateTime lastExecution, String lastStatus) {
        SchedulerConfigEntity entity = currentSchedules.get(taskName);
        if (entity != null) {
            entity.setLastExecution(lastExecution);
            entity.setLastStatus(lastStatus);
            repository.save(entity);
            currentSchedules.put(taskName, entity);
        }
    }

    public void updateStatusOnly(String taskName, String lastStatus) {
        SchedulerConfigEntity entity = currentSchedules.get(taskName);
        if (entity != null) {
            entity.setLastStatus(lastStatus);
            repository.save(entity);
            currentSchedules.put(taskName, entity);
        }
    }
}