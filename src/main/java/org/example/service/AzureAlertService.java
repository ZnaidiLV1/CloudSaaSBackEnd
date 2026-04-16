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
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
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

    public List<AzureAlert> fetchLastDayAlerts(Vm vm) {
        LocalDateTime from = LocalDateTime.now(ZoneOffset.UTC).minusDays(1);
        return fetchAlertsForVmSince(vm, from);
    }

    public List<AzureAlert> fetchLast30DaysAlerts(Vm vm) {
        LocalDateTime from = LocalDateTime.now(ZoneOffset.UTC).minusDays(30);
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

            String nextLink = null;
            boolean hasMorePages = true;
            int pageCount = 0;

            while (hasMorePages && pageCount < 10) {
                String url;
                if (nextLink == null) {
                    url = String.format(
                            "https://management.azure.com/subscriptions/%s" +
                                    "/providers/Microsoft.AlertsManagement/alerts" +
                                    "?api-version=2019-05-05-preview" +
                                    "&targetResource=%s" +
                                    "&timeRange=30d" +
                                    "&pageCount=100" +
                                    "&sortBy=startDateTime" +
                                    "&sortOrder=desc",
                            subscriptionId, URLEncoder.encode(vmResourceId, StandardCharsets.UTF_8)
                    );
                } else {
                    url = nextLink;
                }

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
                    break;
                }

                JsonNode root = objectMapper.readTree(response.body());
                JsonNode values = root.get("value");

                if (values != null && values.isArray()) {
                    for (JsonNode alertNode : values) {
                        AzureAlert alert = parseAlertNode(alertNode, vm, vmResourceId, vmName);
                        if (alert != null) {
                            result.add(alert);
                        }
                    }
                }

                JsonNode nextLinkNode = root.get("nextLink");
                if (nextLinkNode != null && !nextLinkNode.isNull()) {
                    nextLink = nextLinkNode.asText();
                    hasMorePages = true;
                    pageCount++;
                    log.info("Fetching next page for VM {}, page {}", vm.getName(), pageCount);
                } else {
                    hasMorePages = false;
                }
            }

        } catch (Exception e) {
            log.error("Failed to fetch alerts for VM {}: {}", vm.getName(), e.getMessage());
        }

        log.info("Fetched {} alerts for VM {} since {}", result.size(), vm.getName(), from);
        return result;
    }

    private AzureAlert parseAlertNode(JsonNode alertNode, Vm vm, String vmResourceId, String vmName) {
        try {
            JsonNode ess = alertNode.path("properties").path("essentials");

            String monitorCondition = ess.path("monitorCondition").asText(null);

            String targetResource = ess.path("targetResource").asText(null);
            String targetName = ess.path("targetResourceName").asText(null);
            String startDateTimeRaw = ess.path("startDateTime").asText(null);
            String severity = ess.path("severity").asText("Sev4");
            String alertRule = ess.path("alertRule").asText(null);
            String description = ess.path("description").asText(null);
            String fullAlertId = alertNode.path("id").asText(null);

            String alertId = null;
            if (fullAlertId != null && fullAlertId.contains("/")) {
                String[] parts = fullAlertId.split("/");
                alertId = parts[parts.length - 1];
            }

            if (startDateTimeRaw == null || startDateTimeRaw.isBlank()) {
                return null;
            }

            OffsetDateTime occurredAt = OffsetDateTime.parse(startDateTimeRaw)
                    .withOffsetSameInstant(ZoneOffset.UTC);

            boolean matchesVm = false;

            if (vmResourceId != null && targetResource != null
                    && targetResource.toLowerCase().equals(vmResourceId)) {
                matchesVm = true;
            }

            if (!matchesVm && vmResourceId != null && targetResource != null
                    && targetResource.toLowerCase().contains(vmResourceId)) {
                matchesVm = true;
            }

            if (!matchesVm && targetName != null
                    && targetName.toLowerCase().equals(vmName)) {
                matchesVm = true;
            }

            if (!matchesVm && targetName != null
                    && targetName.toLowerCase().contains(vmName)) {
                matchesVm = true;
            }

            if (!matchesVm) {
                return null;
            }

            Double metricValue = null;
            String metricName = null;
            String metricNamespace = null;
            String operator = null;
            Double threshold = null;

            JsonNode conditions = alertNode.path("properties").path("context").path("condition");
            if (conditions != null && !conditions.isMissingNode()) {
                if (conditions.has("metricValue")) {
                    metricValue = conditions.path("metricValue").asDouble();
                }
                if (conditions.has("metricName")) {
                    metricName = conditions.path("metricName").asText();
                }
                if (conditions.has("metricNamespace")) {
                    metricNamespace = conditions.path("metricNamespace").asText();
                }
                if (conditions.has("operator")) {
                    operator = conditions.path("operator").asText();
                }
                if (conditions.has("threshold")) {
                    threshold = conditions.path("threshold").asDouble();
                }
            }

            if (metricName == null && alertRule != null && alertRule.contains("/metricAlerts/")) {
                try {
                    String token = Objects.requireNonNull(tokenCredential
                                    .getToken(new TokenRequestContext()
                                            .addScopes("https://management.azure.com/.default"))
                                    .block())
                            .getToken();

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
                    }
                } catch (Exception e) {
                    log.warn("Could not fetch metric rule details: {}", e.getMessage());
                }
            }

            String alertName = ess.path("alertRule").asText("Unknown Alert");
            if (alertName.contains("/")) {
                String[] parts = alertName.split("/");
                alertName = parts[parts.length - 1];
            }

            LocalDateTime resolvedTime = null;
            String endDateTimeRaw = ess.path("endDateTime").asText(null);
            if (endDateTimeRaw != null && !endDateTimeRaw.isBlank()) {
                resolvedTime = OffsetDateTime.parse(endDateTimeRaw)
                        .withOffsetSameInstant(ZoneOffset.UTC)
                        .toLocalDateTime();
            }

            LocalDateTime firedTime = null;
            if ("Fired".equals(monitorCondition)) {
                firedTime = occurredAt.toLocalDateTime();
            }

            return AzureAlert.builder()
                    .vm(vm)
                    .azureAlertId(alertId)
                    .alertName(alertName)
                    .severity(severity)
                    .description(description)
                    .occurredAt(occurredAt.toLocalDateTime())
                    .monitorCondition(monitorCondition)
                    .resolvedAt(resolvedTime)
                    .firedAt(firedTime)
                    .alertRule(alertRule)
                    .metricName(metricName)
                    .metricNamespace(metricNamespace)
                    .metricValue(metricValue)
                    .operator(operator)
                    .threshold(threshold)
                    .build();

        } catch (Exception e) {
            log.warn("Skipping malformed alert: {}", e.getMessage());
            return null;
        }
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