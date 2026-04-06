package org.example.service;

import lombok.RequiredArgsConstructor;
import org.example.entity.PerformanceMetric;
import org.example.entity.Vm;
import org.example.repository.PerformanceMetricRepository;
import org.example.repository.VmRepository;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PerformanceService {

    private final PerformanceMetricRepository metricRepository;
    private final AzureMonitoringService azureMonitoringService;
    public final VmRepository vmRepository;

    public void syncMetricsFromAzure() {
        azureMonitoringService.syncMetricsFromAzure();
    }

    public Map<Long, Double> getAvailabilityByMonth(int month, int year) {
        YearMonth yearMonth = YearMonth.of(year, month);
        LocalDateTime from = yearMonth.atDay(1).atStartOfDay();
        LocalDateTime to = yearMonth.atEndOfMonth().atTime(23, 59, 59);

        List<Vm> allVms = vmRepository.findAll();
        Map<Long, Double> result = new HashMap<>();

        for (Vm vm : allVms) {
            Double avgAvailability = metricRepository.avgAvailability(vm.getId(), from, to);
            if (avgAvailability != null) {
                result.put(vm.getId(), Math.round(avgAvailability * 100.0) / 100.0);
            }
        }

        return result;
    }

}