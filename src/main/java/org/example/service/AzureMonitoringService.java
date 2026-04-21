package org.example.service;

import com.azure.monitor.query.MetricsQueryClient;
import com.azure.monitor.query.models.*;
import com.azure.resourcemanager.AzureResourceManager;
import com.azure.resourcemanager.compute.models.VirtualMachine;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.*;
import org.example.repository.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.*;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AzureMonitoringService {

    private final MetricsQueryClient metricsQueryClient;
    private final VmRepository vmRepository;
    private final PerformanceMetricRepository metricRepository;
    public final TagRepository tagRepository;
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
        LocalDateTime hourEnd   = LocalDateTime.now()
                .withMinute(0)
                .withSecond(0)
                .withNano(0);
        LocalDateTime hourStart = hourEnd.minusHours(1);

        List<Vm> vms = vmRepository.findAll();
        for (Vm vm : vms) {
            try {
                fetchAndSaveHourlyMetrics(vm, hourStart, hourEnd);
            } catch (Exception e) {
                log.error("Failed metrics for VM {}: {}", vm.getName(), e.getMessage());
            }
        }
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

        List<Double> cpuValues       = extractValues(result, "Percentage CPU");
        List<Double> ramValues       = extractValues(result, "Available Memory Bytes")
                .stream().map(b -> b / (1024.0 * 1024 * 1024)).toList();
        List<Double> diskReadValues  = extractValues(result, "OS Disk Read Bytes/sec")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> diskWriteValues = extractValues(result, "OS Disk Write Bytes/sec")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> networkInValues  = extractTotalValues(result, "Network In Total")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> networkOutValues = extractTotalValues(result, "Network Out Total")
                .stream().map(b -> b / (1024.0 * 1024.0)).toList();
        List<Double> availValues     = extractValues(result, "VmAvailabilityMetric");

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