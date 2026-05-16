package org.example.azure.service;

import com.azure.monitor.query.LogsQueryClient;
import com.azure.monitor.query.MetricsQueryClient;
import com.azure.monitor.query.models.LogsQueryResult;
import com.azure.monitor.query.models.LogsTableRow;
import com.azure.monitor.query.models.MetricsQueryResult;
import com.azure.monitor.query.models.MetricValue;
import com.azure.monitor.query.models.QueryTimeInterval;
import com.azure.resourcemanager.AzureResourceManager;
import com.azure.resourcemanager.compute.models.VirtualMachine;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.azure.entity.PerformanceMetric;
import org.example.azure.entity.Vm;
import org.example.azure.entity.Workspace;
import org.example.azure.repository.PerformanceMetricRepository;
import org.example.azure.repository.VmRepository;
import org.example.azure.repository.WorkspaceRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class AzureMonitoringService {

    private final MetricsQueryClient metricsQueryClient;
    private final LogsQueryClient logsQueryClient;
    private final VmRepository vmRepository;
    private final WorkspaceRepository workspaceRepository;
    private final PerformanceMetricRepository metricRepository;
    private final AzureResourceManager azure;

    @Value("${azure.subscription-id}")
    private String subscriptionId;

    public List<String> getAllVMProjectTags() {
        Set<String> projectNames = new HashSet<>();

        for (VirtualMachine vm : azure.virtualMachines().list()) {
            System.out.println("VM Name: " + vm.name()
                    + " (Type: " + vm.type() + ")"
                    + ", Resource Group: " + vm.resourceGroupName());

            Map<String, String> tags = vm.tags();
            if (tags != null && !tags.isEmpty()) {
                for (Map.Entry<String, String> tag : tags.entrySet()) {
                    System.out.println("Tag: " + tag.getKey() + " = " + tag.getValue());
                    projectNames.add(tag.getValue());
                }
            } else {
                System.out.println("No tags assigned");
            }
        }

        return new ArrayList<>(projectNames);
    }

    public void syncMetricsFromAzure() {
        LocalDateTime hourEnd = LocalDateTime.now()
                .withMinute(0)
                .withSecond(0)
                .withNano(0);
        LocalDateTime hourStart = hourEnd.minusHours(1);

        List<Vm> vms = vmRepository.findAll();

        for (Vm vm : vms) {
            try {
                fetchAndSaveHourlyMetrics(vm, hourStart, hourEnd);
                updateVmDiskSpaceDynamic(vm);
            } catch (Exception e) {
                log.error("Failed metrics for VM {}: {}", vm.getName(), e.getMessage());
            }
        }
    }

    private void updateVmDiskSpaceDynamic(Vm vm) {
        Workspace workspace = vm.getWorkspace();

        if (workspace == null) {
            log.warn("No workspace linked to VM: {}, trying to discover dynamically", vm.getName());
            workspace = discoverWorkspaceForVm(vm.getName());
            if (workspace == null) {
                log.warn("Could not discover workspace for VM: {}", vm.getName());
                return;
            }
            vm.setWorkspace(workspace);
            vmRepository.save(vm);
            log.info("Dynamically linked VM {} to workspace: {}", vm.getName(), workspace.getName());
        }

        String workspaceId = workspace.getWorkspaceId();
        String vmName = vm.getName();

        String query = String.format("""
            InsightsMetrics
            | where TimeGenerated > ago(2h)
            | where Computer == "%s"
            | where Namespace == "LogicalDisk"
            | where Name in ("FreeSpacePercentage", "FreeSpaceMB")
            | extend MountPoint = tostring(todynamic(Tags)["vm.azm.ms/mountId"])
            | where MountPoint == "/"
            | summarize arg_max(TimeGenerated, *) by Name
            """, vmName);

        try {
            LogsQueryResult result = logsQueryClient.queryWorkspace(
                    workspaceId,
                    query,
                    new QueryTimeInterval(Duration.ofHours(2))
            );

            if (result.getTable() != null && !result.getTable().getRows().isEmpty()) {
                Double freePercent = null;
                Double freeMB = null;
                LocalDateTime lastUpdate = null;

                for (LogsTableRow row : result.getTable().getRows()) {
                    Optional<com.azure.monitor.query.models.LogsTableCell> nameCell = row.getColumnValue("Name");
                    Optional<com.azure.monitor.query.models.LogsTableCell> valCell = row.getColumnValue("Val");
                    Optional<com.azure.monitor.query.models.LogsTableCell> timeCell = row.getColumnValue("TimeGenerated");

                    if (nameCell.isPresent() && valCell.isPresent()) {
                        String metricName = nameCell.get().getValueAsString();
                        Double metricValue = valCell.get().getValueAsDouble();

                        if (metricName.equals("FreeSpacePercentage")) {
                            freePercent = metricValue;
                        } else if (metricName.equals("FreeSpaceMB")) {
                            freeMB = metricValue;
                        }

                        if (timeCell.isPresent() && lastUpdate == null) {
                            try {
                                String timeStr = timeCell.get().getValueAsString().replace("Z", "");
                                LocalDateTime utcTime = LocalDateTime.parse(timeStr);
                                // Add 1 hour to convert from UTC to UTC+1
                                lastUpdate = utcTime.plusHours(1);
                            } catch (Exception e) {
                                lastUpdate = LocalDateTime.now();
                            }
                        }
                    }
                }

                boolean updated = false;

                if (freePercent != null) {
                    vm.setDiskFreePercent(freePercent);
                    updated = true;
                }
                if (freeMB != null) {
                    vm.setDiskFreeMB(freeMB);
                    vm.setDiskFreeGB(freeMB / 1024);
                    updated = true;
                }
                if (lastUpdate != null) {
                    vm.setDiskLastUpdated(lastUpdate);
                    updated = true;
                }

                if (updated) {
                    vmRepository.save(vm);
                    log.info("Updated disk space for VM {}: {}% free ({} MB / {} GB) at {}",
                            vm.getName(),
                            freePercent != null ? Math.round(freePercent * 100.0) / 100.0 : "N/A",
                            freeMB != null ? Math.round(freeMB * 100.0) / 100.0 : "N/A",
                            freeMB != null ? Math.round((freeMB / 1024) * 100.0) / 100.0 : "N/A",
                            lastUpdate);
                } else {
                    log.warn("No disk space data found for VM: {}", vm.getName());
                }
            } else {
                log.warn("No disk space data found for VM: {}", vm.getName());
            }
        } catch (Exception e) {
            log.error("Failed to update disk space for VM {}: {}", vm.getName(), e.getMessage());
        }
    }

    private Workspace discoverWorkspaceForVm(String vmName) {
        List<Workspace> allWorkspaces = workspaceRepository.findAll();

        for (Workspace workspace : allWorkspaces) {
            try {
                String query = String.format(
                        "Heartbeat | where Computer == \"%s\" | where TimeGenerated > ago(1h) | summarize count()",
                        vmName
                );

                LogsQueryResult result = logsQueryClient.queryWorkspace(
                        workspace.getWorkspaceId(),
                        query,
                        new QueryTimeInterval(Duration.ofHours(1))
                );

                if (result.getTable() != null && !result.getTable().getRows().isEmpty()) {
                    log.info("Discovered VM {} in workspace: {}", vmName, workspace.getName());
                    return workspace;
                }
            } catch (Exception e) {
                log.debug("VM {} not in workspace {}: {}", vmName, workspace.getName(), e.getMessage());
            }
        }
        return null;
    }

    private void fetchAndSaveHourlyMetrics(Vm vm,
                                           LocalDateTime hourStart, LocalDateTime hourEnd) {

        String resourceId = buildResourceId(vm);

        QueryTimeInterval interval = new QueryTimeInterval(
                hourStart.atOffset(ZoneOffset.UTC),
                hourEnd.atOffset(ZoneOffset.UTC)
        );

        MetricsQueryResult result = metricsQueryClient.queryResource(
                resourceId,
                List.of("Percentage CPU", "Available Memory Bytes", "OS Disk Read Bytes/sec", "OS Disk Write Bytes/sec", "Network In Total", "Network Out Total", "VmAvailabilityMetric")
        );

        List<Double> cpuValues = extractValues(result, "Percentage CPU");
        List<Double> ramValues = extractValues(result, "Available Memory Bytes")
                .stream().map(b -> b / (1024.0 * 1024 * 1024)).toList();
        List<Double> diskReadValues = extractValues(result, "OS Disk Read Bytes/sec")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> diskWriteValues = extractValues(result, "OS Disk Write Bytes/sec")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> networkInValues = extractTotalValues(result, "Network In Total")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> networkOutValues = extractTotalValues(result, "Network Out Total")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> availValues = extractValues(result, "VmAvailabilityMetric");

        double availabilityPercent = availValues.isEmpty() ? 100.0
                : (availValues.stream().filter(v -> v >= 1.0).count()
                / (double) availValues.size()) * 100.0;

        PerformanceMetric metric = PerformanceMetric.builder()
                .vm(vm)
                .cpuMax(max(cpuValues))
                .cpuMin(min(cpuValues))
                .cpuAvg(avg(cpuValues))
                .ramMax(max(ramValues))
                .ramMin(min(ramValues))
                .ramAvg(avg(ramValues))
                .diskRead(avg(diskReadValues))
                .diskWrite(avg(diskWriteValues))
                .networkIn(avg(networkInValues))
                .networkOut(avg(networkOutValues))
                .availabilityPercent(availabilityPercent)
                .savedAt(LocalDateTime.now())
                .build();

        metricRepository.save(metric);
        log.info("Saved hourly metrics for VM {} | CPU avg={} max={} | Availability={} | DiskRead={} | NetworkIn={}",
                vm.getName(), round(metric.getCpuAvg()), round(metric.getCpuMax()), round(availabilityPercent),
                round(metric.getDiskRead()), round(metric.getNetworkIn()));
    }

    private String buildResourceId(Vm vm) {
        return String.format(
                "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Compute/virtualMachines/%s",
                subscriptionId, vm.getResourceGroup(), vm.getName()
        );
    }

    private List<Double> extractValues(MetricsQueryResult result, String metricName) {
        return result.getMetrics().stream()
                .filter(m -> m.getMetricName().equalsIgnoreCase(metricName))
                .findFirst()
                .map(m -> m.getTimeSeries().stream().findFirst()
                        .map(ts -> ts.getValues().stream()
                                .filter(v -> v.getAverage() != null)
                                .map(MetricValue::getAverage)
                                .toList())
                        .orElse(List.of()))
                .orElse(List.of());
    }

    private List<Double> extractTotalValues(MetricsQueryResult result, String metricName) {
        return result.getMetrics().stream()
                .filter(m -> m.getMetricName().equalsIgnoreCase(metricName))
                .findFirst()
                .map(m -> m.getTimeSeries().stream().findFirst()
                        .map(ts -> ts.getValues().stream()
                                .filter(v -> v.getTotal() != null)
                                .map(MetricValue::getTotal)
                                .toList())
                        .orElse(List.of()))
                .orElse(List.of());
    }

    private Double max(List<Double> values) {
        return values.isEmpty() ? null : values.stream().mapToDouble(Double::doubleValue).max().orElse(0.0);
    }

    private Double min(List<Double> values) {
        return values.isEmpty() ? null : values.stream().mapToDouble(Double::doubleValue).min().orElse(0.0);
    }

    private Double avg(List<Double> values) {
        return values.isEmpty() ? null : values.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
    }

    private double round(Double value) {
        return value == null ? 0.0 : Math.round(value * 100.0) / 100.0;
    }
}