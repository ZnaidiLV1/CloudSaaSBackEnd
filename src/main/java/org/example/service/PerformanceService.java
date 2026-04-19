package org.example.service;

import lombok.RequiredArgsConstructor;
import org.example.dto.performanceDto.DailyAvailableRam;
import org.example.dto.performanceDto.DailyPerformance;
import org.example.dto.performanceDto.VmAvailableRamResponse;
import org.example.dto.performanceDto.VmPerformanceResponse;
import org.example.dto.performanceDto.VmPerformanceSummary;
import org.example.entity.PerformanceMetric;
import org.example.entity.Vm;
import org.example.repository.PerformanceMetricRepository;
import org.example.repository.VmRepository;
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
            DailyPerformance dailyPerf = calculateDailyPerformance(vmId, date);
            dailyPerformances.add(dailyPerf);
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

        double avgMaxCpu = calculateAverage(dailyMaxCpus);
        double avgCpu = calculateAverage(dailyAvgCpus);
        double avgMaxRam = calculateAverage(dailyMaxRams);
        double avgRam = calculateAverage(dailyAvgRams);

        return VmPerformanceSummary.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .avgMaxCpu(Math.round(avgMaxCpu * 100.0) / 100.0)
                .avgCpu(Math.round(avgCpu * 100.0) / 100.0)
                .avgMaxRamPercentage(Math.round(avgMaxRam * 100.0) / 100.0)
                .avgRamPercentage(Math.round(avgRam * 100.0) / 100.0)
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
            DailyAvailableRam dailyAvailable = calculateDailyAvailableRam(vmId, date);
            dailyAvailableRams.add(dailyAvailable);
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
                .min(Comparator.comparing(PerformanceMetric::getRamMin, Comparator.nullsLast(Double::compareTo))
                        .thenComparing(m -> m.getSavedAt() != null ? m.getSavedAt() : LocalDateTime.MAX, Comparator.nullsLast(Comparator.naturalOrder())))
                .orElse(null);

        if (minRamMetric == null || minRamMetric.getRamMin() == null) {
            return DailyAvailableRam.builder()
                    .date(date.format(DATE_FORMATTER))
                    .availableRamPercentage(0.0)
                    .timestamp("")
                    .build();
        }

        double usedRamPercentage = (minRamMetric.getRamMin() / TOTAL_RAM_GB) * 100.0;
        double availableRamPercentage = 100.0 - usedRamPercentage;
        availableRamPercentage = Math.round(availableRamPercentage * 100.0) / 100.0;

        String timestamp = minRamMetric.getSavedAt() != null
                ? minRamMetric.getSavedAt().format(TIME_FORMATTER)
                : "";

        return DailyAvailableRam.builder()
                .date(date.format(DATE_FORMATTER))
                .availableRamPercentage(availableRamPercentage)
                .timestamp(timestamp)
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
                    .maxRamPercentage(0.0)
                    .maxRamTime("")
                    .build();
        }

        PerformanceMetric maxCpuMetric = metrics.stream()
                .filter(m -> m.getCpuMax() != null)
                .max(Comparator.comparing(PerformanceMetric::getCpuMax, Comparator.nullsLast(Double::compareTo))
                        .thenComparing(m -> m.getSavedAt() != null ? m.getSavedAt() : LocalDateTime.MIN, Comparator.nullsLast(Comparator.naturalOrder())))
                .orElse(null);

        PerformanceMetric maxRamMetric = metrics.stream()
                .filter(m -> m.getRamMax() != null)
                .max(Comparator.comparing((PerformanceMetric m) -> {
                            Double ramMax = m.getRamMax();
                            return ramMax != null ? (ramMax / TOTAL_RAM_GB) * 100.0 : -1.0;
                        }, Comparator.nullsLast(Double::compareTo))
                        .thenComparing(m -> m.getSavedAt() != null ? m.getSavedAt() : LocalDateTime.MIN, Comparator.nullsLast(Comparator.naturalOrder())))
                .orElse(null);

        double maxRamPercentage = 0.0;
        if (maxRamMetric != null && maxRamMetric.getRamMax() != null) {
            maxRamPercentage = (maxRamMetric.getRamMax() / TOTAL_RAM_GB) * 100.0;
        }

        return DailyPerformance.builder()
                .date(date.format(DATE_FORMATTER))
                .maxCpu(maxCpuMetric != null && maxCpuMetric.getCpuMax() != null ? maxCpuMetric.getCpuMax() : 0.0)
                .maxCpuTime(maxCpuMetric != null && maxCpuMetric.getSavedAt() != null ? maxCpuMetric.getSavedAt().format(TIME_FORMATTER) : "")
                .maxRamPercentage(Math.round(maxRamPercentage * 100.0) / 100.0)
                .maxRamTime(maxRamMetric != null && maxRamMetric.getSavedAt() != null ? maxRamMetric.getSavedAt().format(TIME_FORMATTER) : "")
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
                .filter(m -> m.getRamMax() != null)
                .mapToDouble(m -> (m.getRamMax() / TOTAL_RAM_GB) * 100.0)
                .max()
                .orElse(0.0);

        double avgRamPercentage = metrics.stream()
                .filter(m -> m.getRamAvg() != null)
                .mapToDouble(m -> (m.getRamAvg() / TOTAL_RAM_GB) * 100.0)
                .average()
                .orElse(0.0);

        return new DailyAggregation(true, maxCpu, avgCpu, maxRamPercentage, avgRamPercentage);
    }

    private double calculateAverage(List<Double> values) {
        if (values == null || values.isEmpty()) {
            return 0.0;
        }
        return values.stream()
                .filter(v -> v != null)
                .mapToDouble(Double::doubleValue)
                .average()
                .orElse(0.0);
    }

    private LocalDate parseDate(String dateStr) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return LocalDate.parse(dateStr, formatter);
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