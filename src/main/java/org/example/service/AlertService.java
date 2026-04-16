package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.AzureAlert;
import org.example.entity.Vm;
import org.example.repository.AzureAlertRepository;
import org.example.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

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