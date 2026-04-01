package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.AzureAlert;
import org.example.entity.Vm;
import org.example.repository.AzureAlertRepository;
import org.example.repository.VmRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
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
                List<AzureAlert> fetched =
                        azureAlertService.fetchLastTwoHoursAlerts(vm);

                for (AzureAlert alert : fetched) {
                    if (alertRepository.existsByAzureAlertId(
                            alert.getAzureAlertId())) {
                        log.debug("Alert {} already exists, skipping",
                                alert.getAzureAlertId());
                        continue;
                    }
                    alertRepository.save(alert);
                    log.info("Saved new alert '{}' for VM {}",
                            alert.getAlertName(), vm.getName());
                }

            } catch (Exception e) {
                log.error("Failed alert sync for VM {}: {}",
                        vm.getName(), e.getMessage());
            }
        }
    }

    public List<AzureAlert> getAlertsForVm(Long vmId,
                                           LocalDateTime from, LocalDateTime to) {
        return alertRepository
                .findByVmIdAndOccurredAtBetweenOrderByOccurredAtDesc(
                        vmId, from, to);
    }

    public List<AzureAlert> getLatestAlertsForVm(Long vmId) {
        return alertRepository.findTop20ByVmIdOrderByOccurredAtDesc(vmId);
    }

    public List<AzureAlert> getAlertsByProduct(String product,
                                               LocalDateTime from, LocalDateTime to) {
        return alertRepository.findByProductAndPeriod(product, from, to);
    }
}