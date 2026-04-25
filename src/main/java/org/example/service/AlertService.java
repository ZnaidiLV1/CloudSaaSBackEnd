package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.AlertsDto.*;
import org.example.entity.AzureAlert;
import org.example.entity.Vm;
import org.example.repository.AzureAlertRepository;
import org.example.repository.VmRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlertService {

    private final AzureAlertRepository alertRepository;
    private final VmRepository vmRepository;
    private final AzureAlertService azureAlertService;

    @Transactional
    public void syncLastDayAlerts() {
        log.info("=== SYNC LAST DAY ALERTS START ===");

        List<Vm> vms = vmRepository.findAll();
        log.info("Found {} VMs", vms.size());

        for (Vm vm : vms) {
            try {
                List<AzureAlert> fetchedAlerts = azureAlertService.fetchLastDayAlerts(vm);
                log.info("VM {} - fetched {} alerts", vm.getName(), fetchedAlerts.size());

                for (AzureAlert alert : fetchedAlerts) {
                    saveOrUpdateAlert(alert);
                }

            } catch (Exception e) {
                log.error("Failed sync for VM {}: {}", vm.getName(), e.getMessage());
            }
        }

        log.info("=== SYNC LAST DAY ALERTS COMPLETE ===");
    }

    @Transactional
    public void syncLast30DaysAlerts() {
        log.info("=== SYNC LAST 30 DAYS ALERTS START ===");

        List<Vm> vms = vmRepository.findAll();
        log.info("Found {} VMs", vms.size());

        for (Vm vm : vms) {
            try {
                List<AzureAlert> fetchedAlerts = azureAlertService.fetchLast30DaysAlerts(vm);
                log.info("VM {} - fetched {} alerts", vm.getName(), fetchedAlerts.size());

                for (AzureAlert alert : fetchedAlerts) {
                    saveOrUpdateAlert(alert);
                }

            } catch (Exception e) {
                log.error("Failed sync for VM {}: {}", vm.getName(), e.getMessage());
            }
        }

        log.info("=== SYNC LAST 30 DAYS ALERTS COMPLETE ===");
    }

    public AlertPageResponse getAlertsByVmId(Long vmId, int index) {
        int pageSize = 6;

        Pageable pageable = PageRequest.of(index, pageSize, Sort.by(Sort.Direction.DESC, "occurredAt"));
        Page<AzureAlert> alertsPage;
        int totalCount;
        String vmName = null;

        if (vmId == 0) {
            alertsPage = alertRepository.findAllWithVm(pageable);
            totalCount = (int) alertRepository.count();
            vmName = "All VMs";
        } else {
            Vm vm = vmRepository.findById(vmId)
                    .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));
            vmName = vm.getName();
            alertsPage = alertRepository.findByVmIdWithVm(vmId, pageable);
            totalCount = Math.toIntExact(alertRepository.countByVmId(vmId));
        }

        List<org.example.dto.AlertsDto.AlertDto> alerts = alertsPage.getContent().stream()
                .map(alert -> {
                    String cleanAlertName = alert.getAlertName();
                    if (cleanAlertName != null && cleanAlertName.contains("] ")) {
                        cleanAlertName = cleanAlertName.substring(cleanAlertName.indexOf("] ") + 2);
                    }
                    return org.example.dto.AlertsDto.AlertDto.builder()
                            .alertName(cleanAlertName)
                            .occurredAt(alert.getOccurredAt())
                            .monitorCondition(alert.getMonitorCondition())
                            .description(alert.getDescription())
                            .vmName(alert.getVm().getName())
                            .build();
                })
                .collect(Collectors.toList());

        boolean hasNext = (long) (index + 1) * pageSize < totalCount;
        boolean hasPrevious = index > 0;

        return AlertPageResponse.builder()
                .alerts(alerts)
                .vmName(vmName)
                .index(index)
                .hasNext(hasNext)
                .hasPrevious(hasPrevious)
                .totalCount(totalCount)
                .build();
    }

    public AlertSummaryResponse getAlertSummary(Long vmId, String startDateStr, String endDateStr) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate startLocalDate = LocalDate.parse(startDateStr, formatter);
        LocalDate endLocalDate = LocalDate.parse(endDateStr, formatter);

        LocalDateTime startDateTime = startLocalDate.atStartOfDay();
        LocalDateTime endDateTime = endLocalDate.atTime(LocalTime.MAX);

        String vmName;
        Long totalCount;
        Long firedCount;
        Long resolvedCount;
        List<AlertGroupDto> alertGroups;

        if (vmId == 0) {
            vmName = "All VMs";
            totalCount = alertRepository.countByOccurredAtBetween(startDateTime, endDateTime);
            firedCount = alertRepository.countByMonitorConditionAndOccurredAtBetween("Fired", startDateTime, endDateTime);
            resolvedCount = alertRepository.countByMonitorConditionAndOccurredAtBetween("Resolved", startDateTime, endDateTime);

            List<Object[]> groupResults = alertRepository.countGroupByAlertNameAndDateRange(startDateTime, endDateTime);
            alertGroups = groupResults.stream()
                    .map(result -> {
                        String alertName = (String) result[0];
                        if (alertName != null && alertName.contains("] ")) {
                            alertName = alertName.substring(alertName.indexOf("] ") + 2);
                        }
                        return AlertGroupDto.builder()
                                .alertName(alertName)
                                .count((Long) result[1])
                                .build();
                    })
                    .collect(Collectors.toList());
        } else {
            Vm vm = vmRepository.findById(vmId)
                    .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));
            vmName = vm.getName();
            totalCount = alertRepository.countByVmIdAndOccurredAtBetween(vmId, startDateTime, endDateTime);
            firedCount = alertRepository.countByVmIdAndMonitorConditionAndOccurredAtBetween(vmId, "Fired", startDateTime, endDateTime);
            resolvedCount = alertRepository.countByVmIdAndMonitorConditionAndOccurredAtBetween(vmId, "Resolved", startDateTime, endDateTime);

            List<Object[]> groupResults = alertRepository.countByVmIdGroupByAlertNameAndDateRange(vmId, startDateTime, endDateTime);
            alertGroups = groupResults.stream()
                    .map(result -> {
                        String alertName = (String) result[0];
                        if (alertName != null && alertName.contains("] ")) {
                            alertName = alertName.substring(alertName.indexOf("] ") + 2);
                        }
                        return AlertGroupDto.builder()
                                .alertName(alertName)
                                .count((Long) result[1])
                                .build();
                    })
                    .collect(Collectors.toList());
        }

        return AlertSummaryResponse.builder()
                .vmId(vmId)
                .vmName(vmName)
                .alertGroups(alertGroups)
                .firedCount(firedCount)
                .resolvedCount(resolvedCount)
                .totalCount(totalCount)
                .build();
    }


    public AlertHeatmapResponse getAlertHeatmap(Long vmId) {
        LocalDate endDate = LocalDate.now().minusDays(1);
        LocalDate startDate = endDate.minusDays(27);

        LocalDateTime startDateTime = startDate.atStartOfDay();
        LocalDateTime endDateTime = endDate.atTime(LocalTime.MAX);

        String vmName;
        if (vmId == 0) {
            vmName = "All VMs";
        } else {
            Vm vm = vmRepository.findById(vmId)
                    .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));
            vmName = vm.getName();
        }

        List<Object[]> results = alertRepository.getAlertCountsByDate(vmId, startDateTime, endDateTime);

        Map<String, Long> countMap = new HashMap<>();
        for (Object[] result : results) {
            java.sql.Date sqlDate = (java.sql.Date) result[0];
            LocalDate date = sqlDate.toLocalDate();
            String dateStr = date.toString();
            Long count = (Long) result[1];
            countMap.put(dateStr, count);
        }

        List<HeatmapDataDto> heatmapData = new ArrayList<>();

        LocalDate current = startDate;
        while (!current.isAfter(endDate)) {
            String dateStr = current.toString();
            Long count = countMap.getOrDefault(dateStr, 0L);
            heatmapData.add(HeatmapDataDto.builder()
                    .date(dateStr)
                    .count(count)
                    .build());
            current = current.plusDays(1);
        }

        return AlertHeatmapResponse.builder()
                .vmId(vmId)
                .vmName(vmName)
                .heatmapData(heatmapData)
                .build();
    }

    private void saveOrUpdateAlert(AzureAlert newAlert) {
        Optional<AzureAlert> existingOpt = alertRepository.findByAzureAlertIdAndVmId(
                newAlert.getAzureAlertId(), newAlert.getVm().getId()
        );

        if (existingOpt.isPresent()) {
            AzureAlert existing = existingOpt.get();
            boolean updated = false;

            if ("Resolved".equals(newAlert.getMonitorCondition()) && existing.getResolvedAt() == null) {
                existing.setResolvedAt(newAlert.getOccurredAt());
                existing.setMonitorCondition("Resolved");
                if (newAlert.getMetricValue() != null) {
                    existing.setMetricValue(newAlert.getMetricValue());
                }

                if (existing.getFiredAt() != null) {
                    long duration = ChronoUnit.SECONDS.between(existing.getFiredAt(), newAlert.getOccurredAt());
                    existing.setDurationSeconds(duration);
                    log.info("Calculated duration: {} seconds for alert {}", duration, newAlert.getAzureAlertId());
                }
                updated = true;
                log.info("UPDATED alert {} from FIRED to RESOLVED", newAlert.getAzureAlertId());
            }

            if ("Fired".equals(newAlert.getMonitorCondition()) && existing.getFiredAt() == null) {
                existing.setFiredAt(newAlert.getOccurredAt());
                existing.setMonitorCondition("Fired");
                if (newAlert.getMetricName() != null) existing.setMetricName(newAlert.getMetricName());
                if (newAlert.getMetricNamespace() != null) existing.setMetricNamespace(newAlert.getMetricNamespace());
                if (newAlert.getMetricValue() != null) existing.setMetricValue(newAlert.getMetricValue());
                if (newAlert.getOperator() != null) existing.setOperator(newAlert.getOperator());
                if (newAlert.getThreshold() != null) existing.setThreshold(newAlert.getThreshold());
                updated = true;
                log.info("UPDATED alert {} with FIRED details", newAlert.getAzureAlertId());
            }

            if (updated) {
                alertRepository.save(existing);
            } else {
                log.debug("Alert {} already has state {}, skipping", newAlert.getAzureAlertId(), existing.getMonitorCondition());
            }
        } else {
            if ("Fired".equals(newAlert.getMonitorCondition())) {
                newAlert.setFiredAt(newAlert.getOccurredAt());
                log.info("NEW FIRED alert {} for VM {}", newAlert.getAzureAlertId(), newAlert.getVm().getName());
            } else {
                log.info("NEW RESOLVED alert {} for VM {} (no FIRED found)", newAlert.getAzureAlertId(), newAlert.getVm().getName());
            }
            alertRepository.save(newAlert);
        }
    }
}