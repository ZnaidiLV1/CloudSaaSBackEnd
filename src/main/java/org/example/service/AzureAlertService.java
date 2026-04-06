package org.example.service;

import com.azure.core.credential.TokenCredential;
import com.azure.core.credential.TokenRequestContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.AzureAlert;
import org.example.entity.Vm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

@Service
@Slf4j
@RequiredArgsConstructor
public class AzureAlertService {

    private final TokenCredential tokenCredential;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final ConcurrentHashMap<String, MetricAlertRule> ruleCache = new ConcurrentHashMap<>();

    @Value("${azure.subscription-id}")
    private String subscriptionId;

    public List<AzureAlert> fetchLastTwoHoursAlerts(Vm vm) {
        LocalDateTime from = LocalDateTime.now(ZoneOffset.UTC).minusHours(2);
        return fetchAlertsForVmSince(vm, from);
    }

    public List<AzureAlert> fetchLast48HoursAlerts(Vm vm) {
        LocalDateTime from = LocalDateTime.now(ZoneOffset.UTC).minusHours(48);
        return fetchAlertsForVmSince(vm, from);
    }

    private List<AzureAlert> fetchAlertsForVmSince(Vm vm, LocalDateTime from) {
        List<AzureAlert> result = new ArrayList<>();
        String vmResourceId = vm.getAzureVmId() != null ? vm.getAzureVmId().toLowerCase() : null;
        String vmName = vm.getName().toLowerCase();

        try {
            String token = Objects.requireNonNull(tokenCredential
                            .getToken(new TokenRequestContext()
                                    .addScopes("https://management.azure.com/.default"))
                            .block())
                    .getToken();

            String url = String.format(
                    "https://management.azure.com/subscriptions/%s" +
                            "/providers/Microsoft.AlertsManagement/alerts" +
                            "?api-version=2019-05-05-preview" +
                            "&timeRange=30d" +
                            "&pageCount=250" +
                            "&sortBy=startDateTime" +
                            "&sortOrder=desc",
                    subscriptionId
            );

            HttpClient client = HttpClient.newHttpClient();
            HttpResponse<String> response = client.send(
                    HttpRequest.newBuilder()
                            .uri(URI.create(url))
                            .header("Authorization", "Bearer " + token)
                            .header("Content-Type", "application/json")
                            .GET()
                            .build(),
                    HttpResponse.BodyHandlers.ofString()
            );

            if (response.statusCode() != 200) {
                log.error("Failed to fetch alerts for VM {}: {}", vm.getName(), response.body());
                return result;
            }

            JsonNode root = objectMapper.readTree(response.body());
            JsonNode values = root.get("value");

            if (values == null || !values.isArray()) {
                return result;
            }

            OffsetDateTime cutoff = from.atZone(ZoneOffset.UTC).toOffsetDateTime();

            for (JsonNode alertNode : values) {
                try {
                    JsonNode ess = alertNode.path("properties").path("essentials");

                    String monitorCondition = ess.path("monitorCondition").asText(null);

                    log.info("Alert status for VM {} - monitorCondition: {}", vm.getName(), monitorCondition);

                    if (!"Fired".equals(monitorCondition)) {
                        log.info("Skipping non-Fired alert for VM {} - Status: {}", vm.getName(), monitorCondition);
                        continue;
                    }

                    log.info("Processing FIRED alert for VM {}", vm.getName());

                    String targetResource = ess.path("targetResource").asText(null);
                    String targetName = ess.path("targetResourceName").asText(null);
                    String firedAtRaw = ess.path("startDateTime").asText(null);
                    String severity = ess.path("severity").asText("Sev4");
                    String alertRule = ess.path("alertRule").asText(null);
                    String description = ess.path("description").asText(null);
                    String fullAlertId = alertNode.path("id").asText(null);

                    String alertId = null;
                    if (fullAlertId != null && fullAlertId.contains("/")) {
                        String[] parts = fullAlertId.split("/");
                        alertId = parts[parts.length - 1];
                    }

                    if (firedAtRaw == null || firedAtRaw.isBlank()) {
                        log.warn("No startDateTime for alert, skipping");
                        continue;
                    }

                    OffsetDateTime firedAt = OffsetDateTime.parse(firedAtRaw)
                            .withOffsetSameInstant(ZoneOffset.UTC);

                    if (firedAt.isBefore(cutoff)) {
                        log.info("Alert too old - firedAt: {}, cutoff: {}, skipping", firedAt, cutoff);
                        continue;
                    }

                    boolean matchesVm = false;

                    if (vmResourceId != null && targetResource != null
                            && targetResource.toLowerCase().equals(vmResourceId)) {
                        matchesVm = true;
                        log.info("VM matched by exact resource ID");
                    }

                    if (!matchesVm && vmResourceId != null && targetResource != null
                            && targetResource.toLowerCase().contains(vmResourceId)) {
                        matchesVm = true;
                        log.info("VM matched by contains resource ID");
                    }

                    if (!matchesVm && targetName != null
                            && targetName.toLowerCase().equals(vmName)) {
                        matchesVm = true;
                        log.info("VM matched by exact name");
                    }

                    if (!matchesVm && targetName != null
                            && targetName.toLowerCase().contains(vmName)) {
                        matchesVm = true;
                        log.info("VM matched by contains name");
                    }

                    if (!matchesVm) {
                        log.info("VM mismatch - VM ID: {}, Alert TargetResource: {}, Alert TargetName: {}",
                                vmResourceId, targetResource, targetName);
                        continue;
                    }

                    String metricName = null;
                    String metricNamespace = null;
                    String operator = null;
                    Double threshold = null;

                    if (alertRule != null && alertRule.contains("/metricAlerts/")) {
                        String normalizedRuleId = alertRule.replace("/microsoft.insights/", "/Microsoft.Insights/");

                        MetricAlertRule rule = ruleCache.computeIfAbsent(normalizedRuleId, key -> {
                            try {
                                return fetchMetricAlertRule(key, token);
                            } catch (Exception e) {
                                log.error("Failed to fetch metric rule: {}", e.getMessage());
                                return null;
                            }
                        });

                        if (rule != null) {
                            metricName = rule.getMetricName();
                            metricNamespace = rule.getMetricNamespace();
                            operator = rule.getOperator();
                            threshold = rule.getThreshold();
                            log.info("Got metric rule - Name: {}, Namespace: {}, Operator: {}, Threshold: {}",
                                    metricName, metricNamespace, operator, threshold);
                        }
                    }

                    String alertName = ess.path("alertRule").asText("Unknown Alert");
                    if (alertName.contains("/")) {
                        String[] parts = alertName.split("/");
                        alertName = parts[parts.length - 1];
                    }

                    AzureAlert alert = AzureAlert.builder()
                            .vm(vm)
                            .azureAlertId(alertId)
                            .alertName(alertName)
                            .severity(severity)
                            .description(description)
                            .occurredAt(firedAt.toLocalDateTime())
                            .metricName(metricName)
                            .metricNamespace(metricNamespace)
                            .metricValue(null)
                            .operator(operator)
                            .threshold(threshold)
                            .build();

                    result.add(alert);
                    log.info("Successfully added FIRED alert '{}' for VM {} to result list", alertName, vm.getName());

                } catch (Exception e) {
                    log.warn("Skipping malformed alert: {}", e.getMessage());
                }
            }

        } catch (Exception e) {
            log.error("Failed to fetch alerts for VM {}: {}", vm.getName(), e.getMessage());
        }

        log.info("Fetched {} FIRED alerts for VM {} since {}", result.size(), vm.getName(), from);
        return result;
    }

    private MetricAlertRule fetchMetricAlertRule(String ruleId, String token) throws Exception {
        String[] parts = ruleId.split("/");
        String resourceGroup = parts[4];
        String alertName = parts[8];

        String encodedAlertName = URLEncoder.encode(alertName, StandardCharsets.UTF_8.toString())
                .replace("+", "%20");

        String url = String.format(
                "https://management.azure.com/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Insights/metricAlerts/%s?api-version=2018-03-01",
                subscriptionId, resourceGroup, encodedAlertName);

        log.info("Fetching metric rule from URL: {}", url);

        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response = client.send(
                HttpRequest.newBuilder()
                        .uri(URI.create(url))
                        .header("Authorization", "Bearer " + token)
                        .header("Content-Type", "application/json")
                        .GET()
                        .build(),
                HttpResponse.BodyHandlers.ofString()
        );

        if (response.statusCode() != 200) {
            log.error("Failed to fetch rule. Status: {}, Body: {}", response.statusCode(), response.body());
            throw new RuntimeException("Failed to fetch rule: " + response.body());
        }

        JsonNode root = objectMapper.readTree(response.body());
        JsonNode criteria = root.path("properties").path("criteria");

        String metricName = null;
        String metricNamespace = null;
        String operator = null;
        Double threshold = null;

        if (criteria.has("allOf") && criteria.get("allOf").isArray() && criteria.get("allOf").size() > 0) {
            JsonNode condition = criteria.get("allOf").get(0);
            metricName = condition.path("metricName").asText(null);
            metricNamespace = condition.path("metricNamespace").asText(null);
            operator = condition.path("operator").asText(null);
            if (condition.has("threshold")) {
                JsonNode thresholdNode = condition.get("threshold");
                if (thresholdNode.isNumber()) {
                    threshold = thresholdNode.asDouble();
                } else if (thresholdNode.isTextual()) {
                    try {
                        threshold = Double.parseDouble(thresholdNode.asText());
                    } catch (NumberFormatException e) {
                        log.warn("Could not parse threshold: {}", thresholdNode.asText());
                    }
                }
            }
        }

        log.info("Extracted from rule - metricName: {}, metricNamespace: {}, operator: {}, threshold: {}",
                metricName, metricNamespace, operator, threshold);

        return new MetricAlertRule(metricName, metricNamespace, operator, threshold);
    }

    private static class MetricAlertRule {
        private final String metricName;
        private final String metricNamespace;
        private final String operator;
        private final Double threshold;

        public MetricAlertRule(String metricName, String metricNamespace, String operator, Double threshold) {
            this.metricName = metricName;
            this.metricNamespace = metricNamespace;
            this.operator = operator;
            this.threshold = threshold;
        }

        public String getMetricName() { return metricName; }
        public String getMetricNamespace() { return metricNamespace; }
        public String getOperator() { return operator; }
        public Double getThreshold() { return threshold; }
    }
}