package org.example.service;

import com.azure.identity.ClientSecretCredential;
import com.azure.core.management.profile.AzureProfile;
import com.azure.resourcemanager.alertsmanagement.AlertsManagementManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.AzureAlert;
import org.example.entity.Vm;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class AzureAlertService {

    private final ClientSecretCredential credential;
    private final AzureProfile azureProfile;

    public List<AzureAlert> fetchLastTwoHoursAlerts(Vm vm) {
        AlertsManagementManager manager = AlertsManagementManager
                .authenticate(credential, azureProfile);

        LocalDateTime from = LocalDateTime.now().minusHours(2);
        List<AzureAlert> result = new ArrayList<>();

        manager.alerts().list().forEach(azureAlert -> {
            try {
                var essentials = azureAlert.properties().essentials();
                if (essentials == null) return;

                String targetName = essentials.targetResourceName();
                if (targetName == null ||
                        !targetName.equalsIgnoreCase(vm.getName())) return;

                if (essentials.startDateTime() == null) return;
                LocalDateTime firedAt = essentials.startDateTime()
                        .toLocalDateTime();
                if (firedAt.isBefore(from)) return;

                AzureAlert alert = AzureAlert.builder()
                        .vm(vm)
                        .azureAlertId(azureAlert.id())
                        .alertName(essentials.alertRule())
                        .severity(essentials.severity() != null
                                ? essentials.severity().toString() : "Sev4")
                        .description(essentials.description())
                        .occurredAt(firedAt)
                        .build();

                result.add(alert);

            } catch (Exception e) {
                log.warn("Skipping malformed alert: {}", e.getMessage());
            }
        });

        log.info("Fetched {} alerts from last 2h for VM {}",
                result.size(), vm.getName());
        return result;
    }
}