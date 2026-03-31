package org.example.service;

import lombok.RequiredArgsConstructor;
import org.example.entity.PerformanceMetric;
import org.example.repository.PerformanceMetricRepository;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PerformanceService {

    private final PerformanceMetricRepository metricRepository;
    private final AzureMonitoringService azureMonitoringService;

    public void syncMetricsFromAzure() {
        azureMonitoringService.syncMetricsFromAzure();
    }

}