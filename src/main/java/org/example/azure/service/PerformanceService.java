package org.example.azure.service;

import lombok.RequiredArgsConstructor;
import org.example.azure.dto.performanceDto.*;
import org.example.azure.entity.PerformanceMetric;
import org.example.azure.entity.Vm;
import org.example.azure.repository.PerformanceMetricRepository;
import org.example.azure.repository.VmRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class PerformanceService {

    private final PerformanceMetricRepository metricRepository;
    private final AzureMonitoringService azureMonitoringService;
    public final VmRepository vmRepository;

    private static final double TOTAL_RAM_GB = 8.0;
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    private double toUsedRamPercent(double freeGb) {
        return ((TOTAL_RAM_GB - freeGb) / TOTAL_RAM_GB) * 100.0;
    }

    private double toAvailableRamPercent(double freeGb) {
        return (freeGb / TOTAL_RAM_GB) * 100.0;
    }

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

    public VmPerformanceResponse getVmPerformance(Long vmId, String startDate, String endDate) {
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<LocalDate> dateRange = generateDateRange(start, end);
        List<DailyPerformance> dailyPerformances = new ArrayList<>();

        for (LocalDate date : dateRange) {
            dailyPerformances.add(calculateDailyPerformance(vmId, date));
        }

        return VmPerformanceResponse.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .vmType(vm.getVmType())
                .dailyPerformances(dailyPerformances)
                .build();
    }

    public VmPerformanceSummary getVmPerformanceSummary(Long vmId, String startDate, String endDate) {
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<LocalDate> dateRange = generateDateRange(start, end);

        List<Double> dailyMaxCpus = new ArrayList<>();
        List<Double> dailyAvgCpus = new ArrayList<>();
        List<Double> dailyMaxRams = new ArrayList<>();
        List<Double> dailyAvgRams = new ArrayList<>();

        for (LocalDate date : dateRange) {
            DailyAggregation dailyAgg = calculateDailyAggregation(vmId, date);

            if (dailyAgg.hasData) {
                dailyMaxCpus.add(dailyAgg.maxCpu);
                dailyAvgCpus.add(dailyAgg.avgCpu);
                dailyMaxRams.add(dailyAgg.maxRamPercentage);
                dailyAvgRams.add(dailyAgg.avgRamPercentage);
            }
        }

        return VmPerformanceSummary.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .avgMaxCpu(Math.round(calculateAverage(dailyMaxCpus) * 100.0) / 100.0)
                .avgCpu(Math.round(calculateAverage(dailyAvgCpus) * 100.0) / 100.0)
                .avgMaxRamPercentage(Math.round(calculateAverage(dailyMaxRams) * 100.0) / 100.0)
                .avgRamPercentage(Math.round(calculateAverage(dailyAvgRams) * 100.0) / 100.0)
                .build();
    }

    public VmAvailableRamResponse getVmAvailableRam(Long vmId, String startDate, String endDate) {
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<LocalDate> dateRange = generateDateRange(start, end);
        List<DailyAvailableRam> dailyAvailableRams = new ArrayList<>();

        for (LocalDate date : dateRange) {
            dailyAvailableRams.add(calculateDailyAvailableRam(vmId, date));
        }

        return VmAvailableRamResponse.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .dailyAvailableRam(dailyAvailableRams)
                .build();
    }

    private DailyAvailableRam calculateDailyAvailableRam(Long vmId, LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.atTime(LocalTime.MAX);

        List<PerformanceMetric> metrics = metricRepository.findMetricsByVmIdAndDateRange(vmId, startOfDay, endOfDay);

        if (metrics == null || metrics.isEmpty()) {
            return DailyAvailableRam.builder()
                    .date(date.format(DATE_FORMATTER))
                    .availableRamPercentage(0.0)
                    .timestamp("")
                    .build();
        }

        PerformanceMetric minRamMetric = metrics.stream()
                .filter(m -> m.getRamMin() != null)
                .min(Comparator.comparing(PerformanceMetric::getRamMin, Comparator.nullsLast(Double::compareTo)))
                .orElse(null);

        if (minRamMetric == null || minRamMetric.getRamMin() == null) {
            return DailyAvailableRam.builder()
                    .date(date.format(DATE_FORMATTER))
                    .availableRamPercentage(0.0)
                    .timestamp("")
                    .build();
        }

        double availableRamPercentage = Math.round(toAvailableRamPercent(minRamMetric.getRamMin()) * 100.0) / 100.0;

        String timestamp = minRamMetric.getSavedAt() != null
                ? minRamMetric.getSavedAt().format(TIME_FORMATTER)
                : "";

        return DailyAvailableRam.builder()
                .date(date.format(DATE_FORMATTER))
                .availableRamPercentage(availableRamPercentage)
                .timestamp(timestamp)
                .build();
    }

    public VmDailyRamResponse getVmDailyRam(Long vmId, String date) {
        LocalDate targetDate = parseDate(date);
        LocalDateTime startOfDay = targetDate.atStartOfDay();
        LocalDateTime endOfDay = targetDate.atTime(LocalTime.MAX);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<PerformanceMetric> metrics = metricRepository.findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(vmId, startOfDay, endOfDay);

        List<HourlyRamValue> hourlyRam = new ArrayList<>();

        for (PerformanceMetric metric : metrics) {
            if (metric.getRamMin() != null) {
                String hour = metric.getSavedAt().format(DateTimeFormatter.ofPattern("HH:mm"));
                double usedRamPercentage = Math.round(toUsedRamPercent(metric.getRamMin()) * 100.0) / 100.0;
                hourlyRam.add(HourlyRamValue.builder()
                        .hour(hour)
                        .ramUsedPercentage(usedRamPercentage)
                        .build());
            }
        }

        return VmDailyRamResponse.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .date(targetDate.format(DATE_FORMATTER))
                .hourlyRam(hourlyRam)
                .build();
    }

    public VmDailyAvailableRamResponse getVmDailyAvailableRam(Long vmId, String date) {
        LocalDate targetDate = parseDate(date);
        LocalDateTime startOfDay = targetDate.atStartOfDay();
        LocalDateTime endOfDay = targetDate.atTime(LocalTime.MAX);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<PerformanceMetric> metrics = metricRepository.findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(vmId, startOfDay, endOfDay);

        List<HourlyAvailableRamValue> hourlyAvailableRam = new ArrayList<>();

        for (PerformanceMetric metric : metrics) {
            if (metric.getRamMin() != null) {
                String hour = metric.getSavedAt().format(DateTimeFormatter.ofPattern("HH:mm"));
                double availableRamPercentage = Math.round(toAvailableRamPercent(metric.getRamMin()) * 100.0) / 100.0;
                hourlyAvailableRam.add(HourlyAvailableRamValue.builder()
                        .hour(hour)
                        .availableRamPercentage(availableRamPercentage)
                        .build());
            }
        }

        return VmDailyAvailableRamResponse.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .date(targetDate.format(DATE_FORMATTER))
                .hourlyAvailableRam(hourlyAvailableRam)
                .build();
    }

    public VmDailyCpuResponse getVmDailyCpu(Long vmId, String date) {
        LocalDate targetDate = parseDate(date);
        LocalDateTime startOfDay = targetDate.atStartOfDay();
        LocalDateTime endOfDay = targetDate.atTime(LocalTime.MAX);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<PerformanceMetric> metrics = metricRepository.findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(vmId, startOfDay, endOfDay);

        List<HourlyCpuValue> hourlyCpu = new ArrayList<>();

        for (PerformanceMetric metric : metrics) {
            if (metric.getCpuMax() != null) {
                String hour = metric.getSavedAt().format(TIME_FORMATTER);
                hourlyCpu.add(HourlyCpuValue.builder()
                        .hour(hour)
                        .cpuMax(metric.getCpuMax())
                        .build());
            }
        }

        return VmDailyCpuResponse.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .date(targetDate.format(DATE_FORMATTER))
                .hourlyCpu(hourlyCpu)
                .build();
    }

    public VmMetricTotalResponse getVmMetricTotal(Long vmId, String startDate, String endDate, String metricType) {
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);
        LocalDateTime startDateTime = start.atStartOfDay();
        LocalDateTime endDateTime = end.atTime(LocalTime.MAX);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<Object[]> results;

        switch (metricType.toUpperCase()) {
            case "DISK_READ":
                results = metricRepository.sumDiskReadByDate(vmId, startDateTime, endDateTime);
                break;
            case "DISK_WRITE":
                results = metricRepository.sumDiskWriteByDate(vmId, startDateTime, endDateTime);
                break;
            case "NETWORK_IN":
                results = metricRepository.sumNetworkInByDate(vmId, startDateTime, endDateTime);
                break;
            case "NETWORK_OUT":
                results = metricRepository.sumNetworkOutByDate(vmId, startDateTime, endDateTime);
                break;
            default:
                throw new RuntimeException("Invalid metric type: " + metricType);
        }

        List<DailyMetricTotal> dailyTotals = new ArrayList<>();
        for (Object[] result : results) {
            java.sql.Date sqlDate = (java.sql.Date) result[0];
            Double total = (Double) result[1];

            if (total == null) {
                total = 0.0;
            }

            dailyTotals.add(DailyMetricTotal.builder()
                    .date(sqlDate.toLocalDate().toString())
                    .total(Math.round(total * 1000.0) / 1000.0)
                    .build());
        }

        return VmMetricTotalResponse.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .metricType(metricType)
                .dailyTotals(dailyTotals)
                .build();
    }

    private DailyPerformance calculateDailyPerformance(Long vmId, LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.atTime(LocalTime.MAX);

        List<PerformanceMetric> metrics = metricRepository.findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(
                vmId, startOfDay, endOfDay
        );

        if (metrics == null || metrics.isEmpty()) {
            return DailyPerformance.builder()
                    .date(date.format(DATE_FORMATTER))
                    .maxCpu(0.0)
                    .maxCpuTime("")
                    .maxUsedRamPercentage(0.0)
                    .maxUsedRamTime("")
                    .build();
        }

        PerformanceMetric maxCpuMetric = metrics.stream()
                .filter(m -> m.getCpuMax() != null)
                .max(Comparator.comparing(PerformanceMetric::getCpuMax, Comparator.nullsLast(Double::compareTo)))
                .orElse(null);

        PerformanceMetric minRamMetric = metrics.stream()
                .filter(m -> m.getRamMin() != null)
                .min(Comparator.comparing(PerformanceMetric::getRamMin, Comparator.nullsLast(Double::compareTo)))
                .orElse(null);

        double maxUsedRamPercentage = 0.0;
        String maxUsedRamTime = "";

        if (minRamMetric != null && minRamMetric.getRamMin() != null) {
            double usedRamGB = TOTAL_RAM_GB - minRamMetric.getRamMin();
            maxUsedRamPercentage = Math.round((usedRamGB / TOTAL_RAM_GB) * 100 * 100.0) / 100.0;
            maxUsedRamTime = minRamMetric.getSavedAt() != null
                    ? minRamMetric.getSavedAt().format(TIME_FORMATTER)
                    : "";
        }

        return DailyPerformance.builder()
                .date(date.format(DATE_FORMATTER))
                .maxCpu(maxCpuMetric != null && maxCpuMetric.getCpuMax() != null ? maxCpuMetric.getCpuMax() : 0.0)
                .maxCpuTime(maxCpuMetric != null && maxCpuMetric.getSavedAt() != null ? maxCpuMetric.getSavedAt().format(TIME_FORMATTER) : "")
                .maxUsedRamPercentage(maxUsedRamPercentage)
                .maxUsedRamTime(maxUsedRamTime)
                .build();
    }

    public VmDailyMetricsResponse getVmDailyMetrics(Long vmId, String date) {
        LocalDate targetDate = parseDate(date);
        LocalDateTime startOfDay = targetDate.atStartOfDay();
        LocalDateTime endOfDay = targetDate.atTime(LocalTime.MAX);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<PerformanceMetric> metrics = metricRepository.findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(vmId, startOfDay, endOfDay);

        List<HourlyMetricsValue> hourlyMetrics = new ArrayList<>();

        for (PerformanceMetric metric : metrics) {
            String hour = metric.getSavedAt().format(DateTimeFormatter.ofPattern("HH:mm"));

            hourlyMetrics.add(HourlyMetricsValue.builder()
                    .hour(hour)
                    .networkIn(metric.getNetworkIn() != null ? metric.getNetworkIn() : 0.0)
                    .networkOut(metric.getNetworkOut() != null ? metric.getNetworkOut() : 0.0)
                    .diskRead(metric.getDiskRead() != null ? metric.getDiskRead() : 0.0)
                    .diskWrite(metric.getDiskWrite() != null ? metric.getDiskWrite() : 0.0)
                    .build());
        }

        return VmDailyMetricsResponse.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .date(targetDate.format(DATE_FORMATTER))
                .hourlyMetrics(hourlyMetrics)
                .build();
    }

    private DailyAggregation calculateDailyAggregation(Long vmId, LocalDate date) {
        LocalDateTime startOfDay = date.atStartOfDay();
        LocalDateTime endOfDay = date.atTime(LocalTime.MAX);

        List<PerformanceMetric> metrics = metricRepository.findByVmIdAndSavedAtBetween(
                vmId, startOfDay, endOfDay
        );

        if (metrics == null || metrics.isEmpty()) {
            return new DailyAggregation(false, 0.0, 0.0, 0.0, 0.0);
        }

        double maxCpu = metrics.stream()
                .filter(m -> m.getCpuMax() != null)
                .mapToDouble(PerformanceMetric::getCpuMax)
                .max()
                .orElse(0.0);

        double avgCpu = metrics.stream()
                .filter(m -> m.getCpuAvg() != null)
                .mapToDouble(PerformanceMetric::getCpuAvg)
                .average()
                .orElse(0.0);

        double maxRamPercentage = metrics.stream()
                .filter(m -> m.getRamMin() != null)
                .mapToDouble(m -> toUsedRamPercent(m.getRamMin()))
                .max()
                .orElse(0.0);

        double avgRamPercentage = metrics.stream()
                .filter(m -> m.getRamAvg() != null)
                .mapToDouble(m -> toUsedRamPercent(m.getRamAvg()))
                .average()
                .orElse(0.0);

        return new DailyAggregation(true, maxCpu, avgCpu, maxRamPercentage, avgRamPercentage);
    }

    private double calculateAverage(List<Double> values) {
        if (values == null || values.isEmpty()) return 0.0;
        return values.stream()
                .filter(v -> v != null)
                .mapToDouble(Double::doubleValue)
                .average()
                .orElse(0.0);
    }

    private LocalDate parseDate(String dateStr) {
        return LocalDate.parse(dateStr, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }

    private List<LocalDate> generateDateRange(LocalDate start, LocalDate end) {
        List<LocalDate> dates = new ArrayList<>();
        LocalDate current = start;
        while (!current.isAfter(end)) {
            dates.add(current);
            current = current.plusDays(1);
        }
        return dates;
    }

    private static class DailyAggregation {
        boolean hasData;
        double maxCpu;
        double avgCpu;
        double maxRamPercentage;
        double avgRamPercentage;

        public DailyAggregation(boolean hasData, double maxCpu, double avgCpu, double maxRamPercentage, double avgRamPercentage) {
            this.hasData = hasData;
            this.maxCpu = maxCpu;
            this.avgCpu = avgCpu;
            this.maxRamPercentage = maxRamPercentage;
            this.avgRamPercentage = avgRamPercentage;
        }
    }
}