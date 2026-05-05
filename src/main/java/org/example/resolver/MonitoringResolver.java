package org.example.resolver;

import com.azure.resourcemanager.AzureResourceManager;
import org.example.config.SchedulerConfig;
import org.example.service.AlertService;
import org.example.service.AzureMonitoringService;
import org.example.service.CostService;
import org.example.service.PerformanceService;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.List;

@Controller
public class MonitoringResolver {

    private final AzureMonitoringService service;
    public final AzureResourceManager azureResourceManager;
    public final PerformanceService performanceService;
    public final AlertService alertService;
    public final CostService costService;
    private final SchedulerConfig schedulerConfig;

    public MonitoringResolver(AzureMonitoringService service,
                              AzureResourceManager azureResourceManager,
                              PerformanceService performanceService,
                              AlertService alertService,
                              CostService costService, SchedulerConfig schedulerConfig) {
        this.service = service;
        this.azureResourceManager = azureResourceManager;
        this.performanceService = performanceService;
        this.alertService = alertService;
        this.costService = costService;
        this.schedulerConfig = schedulerConfig;
    }

    @QueryMapping
    public List<String> getAllProjectTags() {
        return service.getAllVMProjectTags();
    }

    @QueryMapping
    public String testAzureConnection() {
        try {
            long count = azureResourceManager.resourceGroups().list().stream().count();
            return "Connected! Found " + count + " resource groups.";
        } catch (Exception e) {
            return "FAILED: " + e.getMessage();
        }
    }

    @MutationMapping
    public String triggerMetricsSync() {
        schedulerConfig.updateStatusOnly("performance", "RUNNING");
        try {
            performanceService.syncMetricsFromAzure();
            schedulerConfig.updateExecutionStatus("performance", LocalDateTime.now(), "SUCCESS");
            return "Metrics sync triggered";
        } catch (Exception e) {
            schedulerConfig.updateStatusOnly("performance", "FAILED");
            throw e;
        }
    }

    @MutationMapping
    public String triggerAlertSync() {
        schedulerConfig.updateStatusOnly("alert", "RUNNING");
        try {
            alertService.syncLastDayAlerts();
            schedulerConfig.updateExecutionStatus("alert", LocalDateTime.now(), "SUCCESS");
            return "Alert sync (last 24 hours) triggered";
        } catch (Exception e) {
            schedulerConfig.updateStatusOnly("alert", "FAILED");
            throw e;
        }
    }

    @MutationMapping
    public String triggerAlertSyncLast30Days() {
        alertService.syncLast30DaysAlerts();
        return "Alert sync (last 30 days) triggered";
    }

    @MutationMapping
    public String triggerCostSync() {
        costService.syncDailyCostsFromAzure();
        return "Cost sync triggered";
    }
}