package org.example.resolver;

import com.azure.resourcemanager.AzureResourceManager;
import org.example.service.AlertService;
import org.example.service.AzureMonitoringService;
import org.example.service.CostService;
import org.example.service.PerformanceService;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class MonitoringResolver {

    private final AzureMonitoringService service;
    public final AzureResourceManager azureResourceManager;
    public final PerformanceService performanceService;
    public final AlertService alertService;
    public final CostService costService;

    public MonitoringResolver(AzureMonitoringService service, AzureResourceManager azureResourceManager, PerformanceService performanceService, AlertService alertService, CostService costService) {
        this.service = service;
        this.azureResourceManager = azureResourceManager;
        this.performanceService = performanceService;
        this.alertService = alertService;
        this.costService = costService;
    }

    @QueryMapping
    public List<String> getAllProjectTags(){
        return  service.getAllVMProjectTags();
    }

    @QueryMapping
    public String testAzureConnection() {
        try {
            long count = azureResourceManager
                    .resourceGroups().list().stream().count();
            return "Connected! Found " + count + " resource groups.";
        } catch (Exception e) {
            return "FAILED: " + e.getMessage();
        }
    }

    @MutationMapping
    public String triggerMetricsSync() {
        performanceService.syncMetricsFromAzure();
        return "Metrics sync triggered — check DB and logs";
    }

    @MutationMapping
    public String triggerAlertSync() {
        alertService.syncAlertsFromAzure();
        return "Alert sync triggered — check DB and logs";
    }

    @MutationMapping
    public String triggerCostSync() {
        costService.syncDailyCostsFromAzure();
        return "Cost sync triggered — check DB and logs";
    }


}