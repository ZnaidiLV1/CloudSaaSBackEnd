package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.AzureAlert;
import org.example.entity.Vm;
import org.example.repository.AzureAlertRepository;
import org.example.repository.VmRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AlertService {

    private final AzureAlertRepository alertRepository;
    private final VmRepository vmRepository;
    private final AzureAlertService azureAlertService;

    public void syncAlertsFromAzure() {
        List<Vm> vms = vmRepository.findAll();
        for (Vm vm : vms) {
            try {
                List<AzureAlert> fetched = azureAlertService.fetchLastTwoHoursAlerts(vm);

                for (AzureAlert alert : fetched) {
                    if (alertRepository.existsByAzureAlertId(alert.getAzureAlertId())) {
                        log.debug("Alert {} already exists, skipping", alert.getAzureAlertId());
                        continue;
                    }
                    alertRepository.save(alert);
                    log.info("Saved new alert '{}' for VM {}", alert.getAlertName(), vm.getName());
                }

            } catch (Exception e) {
                log.error("Failed alert sync for VM {}: {}", vm.getName(), e.getMessage());
            }
        }
    }

    public void syncAlertsLast48HoursFromAzure() {
        log.info("=== syncAlertsLast48HoursFromAzure START ===");

        List<Vm> vms;
        try {
            vms = vmRepository.findAll();
            log.info("=== Found {} VMs in DB ===", vms.size());
        } catch (Exception e) {
            log.error("=== FATAL — could not load VMs from DB: {}", e.getMessage(), e);
            return;
        }

        for (Vm vm : vms) {
            log.info("=== Processing VM '{}' (id={}, azureVmId={}) ===", vm.getName(), vm.getId(), vm.getAzureVmId());
            try {
                List<AzureAlert> fetched = azureAlertService.fetchLast48HoursAlerts(vm);
                log.info("=== VM '{}' — {} alerts returned ===", vm.getName(), fetched.size());

                for (AzureAlert alert : fetched) {
                    String alertId = alert.getAzureAlertId();
                    try {
                        if (alertId != null && alertRepository.existsByAzureAlertId(alertId)) {
                            log.info("=== Alert '{}' already in DB, skipping ===", alertId);
                            continue;
                        }
                        alertRepository.save(alert);
                        log.info("=== SAVED alert '{}' for VM '{}' ===", alert.getAlertName(), vm.getName());
                    } catch (Exception e) {
                        log.error("=== Failed to save alert '{}': {} ===", alertId, e.getMessage(), e);
                    }
                }

            } catch (Exception e) {
                log.error("=== Failed 48h alert sync for VM '{}': {} ===", vm.getName(), e.getMessage(), e);
            }
        }

        log.info("=== syncAlertsLast48HoursFromAzure COMPLETE ===");
    }
}