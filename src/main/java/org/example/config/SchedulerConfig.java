package org.example.config;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.SchedulerConfigEntity;
import org.example.repository.SchedulerConfigRepository;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Component
public class SchedulerConfig {

    private static final Map<String, String> DEFAULTS = Map.of(
            "performance", "0 0 * * * *",
            "cost", "0 0 1 * * *",
            "invoice", "0 0 2 11 * *",
            "infra", "0 0 2 * * *",
            "alert", "0 0 2 * * *",
            "monthlyCost", "0 0 2 11 * *"
    );

    private final SchedulerConfigRepository repository;
    private final Map<String, String> currentSchedules = new HashMap<>();

    public SchedulerConfig(SchedulerConfigRepository repository) {
        this.repository = repository;
    }

    @PostConstruct
    public void loadFromDatabase() {
        log.info("Loading scheduler configurations from database...");

        for (String taskName : DEFAULTS.keySet()) {
            SchedulerConfigEntity entity = repository.findById(taskName).orElse(null);

            if (entity == null) {
                entity = new SchedulerConfigEntity(taskName, DEFAULTS.get(taskName));
                repository.save(entity);
                currentSchedules.put(taskName, DEFAULTS.get(taskName));
                log.info("Initialized {} with default: {}", taskName, DEFAULTS.get(taskName));
            } else {
                currentSchedules.put(taskName, entity.getCronExpression());
                log.info("Loaded {} from DB: {}", taskName, entity.getCronExpression());
            }
        }
    }

    // Getters
    public String getPerformanceCron() { return currentSchedules.get("performance"); }
    public String getCostCron() { return currentSchedules.get("cost"); }
    public String getInvoiceCron() { return currentSchedules.get("invoice"); }
    public String getInfraCron() { return currentSchedules.get("infra"); }
    public String getAlertCron() { return currentSchedules.get("alert"); }
    public String getMonthlyCostCron() { return currentSchedules.get("monthlyCost"); }

    // Setters
    public void setPerformanceCron(String cron) { saveToDatabase("performance", cron); }
    public void setCostCron(String cron) { saveToDatabase("cost", cron); }
    public void setInvoiceCron(String cron) { saveToDatabase("invoice", cron); }
    public void setInfraCron(String cron) { saveToDatabase("infra", cron); }
    public void setAlertCron(String cron) { saveToDatabase("alert", cron); }
    public void setMonthlyCostCron(String cron) { saveToDatabase("monthlyCost", cron); }

    private void saveToDatabase(String taskName, String cronExpression) {
        currentSchedules.put(taskName, cronExpression);
        SchedulerConfigEntity entity = new SchedulerConfigEntity(taskName, cronExpression);
        repository.save(entity);
        log.info("Persisted {} schedule to DB: {}", taskName, cronExpression);
    }

    public Map<String, String> getAllSchedules() {
        return new HashMap<>(currentSchedules);
    }
}