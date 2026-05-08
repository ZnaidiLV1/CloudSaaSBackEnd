package org.example.service;

import com.azure.core.credential.TokenCredential;
import com.azure.core.credential.TokenRequestContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.AzureAlert;
import org.example.entity.Vm;
import org.example.repository.AzureAlertRepository;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@Slf4j
@RequiredArgsConstructor
public class AzureAlertService {

    private final TokenCredential tokenCredential;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final ConcurrentHashMap<String, MetricAlertRule> ruleCache = new ConcurrentHashMap<>();
    private final AzureAlertRepository alertRepository;  // ADD THIS - inject your repository

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

            long daysDiff = java.time.Duration.between(from, LocalDateTime.now(ZoneOffset.UTC)).toDays();
            String timeRangeParam;
            if (daysDiff <= 1) {
                timeRangeParam = "1d";
            } else if (daysDiff <= 7) {
                timeRangeParam = "7d";
            } else {
                timeRangeParam = "30d";
            }

            while (hasMorePages && pageCount < 10) {
                String url;
                if (nextLink == null) {
                    url = String.format(
                            "https://management.azure.com/subscriptions/%s" +
                                    "/providers/Microsoft.AlertsManagement/alerts" +
                                    "?api-version=2019-05-05-preview" +
                                    "&targetResource=%s" +
                                    "&timeRange=%s" +
                                    "&pageCount=100" +
                                    "&sortBy=startDateTime" +
                                    "&sortOrder=desc",
                            subscriptionId, URLEncoder.encode(vmResourceId, StandardCharsets.UTF_8), timeRangeParam
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
                        JsonNode ess = alertNode.path("properties").path("essentials");
                        String startDateTimeRaw = ess.path("startDateTime").asText(null);
                        if (startDateTimeRaw != null) {
                            OffsetDateTime startDateTime = OffsetDateTime.parse(startDateTimeRaw);
                            LocalDateTime alertTime = startDateTime.toLocalDateTime();
                            if (alertTime.isAfter(from)) {
                                AzureAlert alert = parseAlertNode(alertNode, vm, vmResourceId, vmName, token);
                                if (alert != null) {
                                    // ADD THIS BLOCK - check and update existing alert
                                    AzureAlert existingAlert = alertRepository.findByAzureAlertId(alert.getAzureAlertId());

                                    if (existingAlert != null) {
                                        // Alert exists in DB
                                        if ("Fired".equals(existingAlert.getMonitorCondition()) &&
                                                "Resolved".equals(alert.getMonitorCondition())) {
                                            // Update existing FIRED alert to RESOLVED
                                            existingAlert.setMonitorCondition("Resolved");
                                            existingAlert.setResolvedAt(alert.getResolvedAt());
                                            // PRESERVE the metric value from the existing alert (don't overwrite with null)
                                            // existingAlert already has the metric value from when it was fired
                                            AzureAlert savedAlert = alertRepository.save(existingAlert);
                                            result.add(savedAlert);
                                            log.info("UPDATED alert {} from FIRED to RESOLVED - firedAt={}, resolvedAt={}, metricValue={}",
                                                    alert.getAzureAlertId(), savedAlert.getFiredAt(), savedAlert.getResolvedAt(), savedAlert.getMetricValue());
                                        } else {
                                            // Alert already exists and doesn't need update, skip adding to result
                                            log.debug("Alert {} already exists with condition {}", alert.getAzureAlertId(), existingAlert.getMonitorCondition());
                                        }
                                    } else {
                                        // New alert, save it
                                        AzureAlert savedAlert = alertRepository.save(alert);
                                        result.add(savedAlert);
                                        log.info("SAVED new alert {} [{}] - metricValue={}", alert.getAzureAlertId(), alert.getMonitorCondition(), alert.getMetricValue());
                                    }
                                }
                            }
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

    private Double fetchMetricValueFromAlertDetails(String alertId, String alertRuleId, String token) {
        try {
            String url = String.format(
                    "https://management.azure.com/subscriptions/%s/providers/Microsoft.AlertsManagement/alerts/%s?api-version=2019-05-05-preview",
                    subscriptionId, alertId
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

            if (response.statusCode() == 200) {
                JsonNode detailedAlert = objectMapper.readTree(response.body());
                JsonNode properties = detailedAlert.path("properties");
                JsonNode context = properties.path("context");
                JsonNode innerContext = context.path("context");
                JsonNode condition = innerContext.path("condition");
                JsonNode allOf = condition.path("allOf");

                if (allOf.isArray() && allOf.size() > 0) {
                    JsonNode criterion = allOf.get(0);
                    if (criterion.has("metricValue") && !criterion.path("metricValue").isNull()) {
                        return criterion.path("metricValue").asDouble();
                    }
                    if (criterion.has("currentValue") && !criterion.path("currentValue").isNull()) {
                        return criterion.path("currentValue").asDouble();
                    }
                }

                JsonNode additionalProps = properties.path("additionalProperties");
                if (!additionalProps.isMissingNode() && additionalProps.has("metricValue")) {
                    return additionalProps.path("metricValue").asDouble();
                }
            }
        } catch (Exception e) {
            log.warn("Alert {} - Error fetching metric value: {}", alertId, e.getMessage());
        }
        return null;
    }

    private AzureAlert parseAlertNode(JsonNode alertNode, Vm vm, String vmResourceId, String vmName, String token) {
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

            String alertId;
            if (fullAlertId != null && fullAlertId.contains("/")) {
                String[] parts = fullAlertId.split("/");
                alertId = parts[parts.length - 1];
            } else {
                alertId = null;
            }

            if (startDateTimeRaw == null || startDateTimeRaw.isBlank()) {
                log.warn("Alert {} - no startDateTime, skipping", alertId);
                return null;
            }

            OffsetDateTime startDateTime = OffsetDateTime.parse(startDateTimeRaw)
                    .withOffsetSameInstant(ZoneOffset.UTC);

            LocalDateTime occurredAt = startDateTime.toLocalDateTime();
            LocalDateTime firedAt = startDateTime.toLocalDateTime();

            String resolvedDateTimeRaw = null;
            LocalDateTime resolvedAt = null;

            if (ess.has("monitorConditionResolvedDateTime") && !ess.path("monitorConditionResolvedDateTime").isNull()) {
                resolvedDateTimeRaw = ess.path("monitorConditionResolvedDateTime").asText();
                if (resolvedDateTimeRaw != null && !resolvedDateTimeRaw.isBlank()) {
                    resolvedAt = OffsetDateTime.parse(resolvedDateTimeRaw)
                            .withOffsetSameInstant(ZoneOffset.UTC)
                            .toLocalDateTime();
                }
            }

            boolean matchesVm = false;
            if (vmResourceId != null && targetResource != null
                    && targetResource.toLowerCase().equals(vmResourceId)) matchesVm = true;
            if (!matchesVm && vmResourceId != null && targetResource != null
                    && targetResource.toLowerCase().contains(vmResourceId)) matchesVm = true;
            if (!matchesVm && targetName != null && targetName.toLowerCase().equals(vmName)) matchesVm = true;
            if (!matchesVm && targetName != null && targetName.toLowerCase().contains(vmName)) matchesVm = true;
            if (!matchesVm) {
                return null;
            }

            Double metricValue = null;
            String metricName = null;
            String metricNamespace = null;
            String operator = null;
            Double threshold = null;

            // ONLY fetch metric value for FIRED alerts
            if (alertId != null && alertRule != null && "Fired".equals(monitorCondition)) {
                metricValue = fetchMetricValueFromAlertDetails(alertId, alertRule, token);
            }

            JsonNode context = alertNode.path("properties").path("context");
            if (!context.isMissingNode() && !context.isNull()) {
                JsonNode condition = context.path("condition");
                JsonNode allOf = condition.path("allOf");
                if (allOf.isArray() && allOf.size() > 0) {
                    JsonNode first = allOf.get(0);
                    if (metricValue == null && first.has("metricValue") && !first.path("metricValue").isNull()) {
                        metricValue = first.path("metricValue").asDouble();
                    }
                    if (metricName == null) metricName = first.path("metricName").asText();
                    if (metricNamespace == null) metricNamespace = first.path("metricNamespace").asText();
                    if (operator == null) operator = first.path("operator").asText();
                    if (threshold == null) {
                        JsonNode thresholdNode = first.get("threshold");
                        if (thresholdNode.isNumber()) threshold = thresholdNode.asDouble();
                        else if (thresholdNode.isTextual()) {
                            try { threshold = Double.parseDouble(thresholdNode.asText()); } catch (Exception e) {}
                        }
                    }
                }
            }

            if (metricValue == null && "Fired".equals(monitorCondition)) {
                JsonNode additionalProps = alertNode.path("properties").path("additionalProperties");
                if (!additionalProps.isMissingNode() && !additionalProps.isNull()) {
                    if (additionalProps.has("metricValue") && !additionalProps.path("metricValue").isNull()) {
                        metricValue = additionalProps.path("metricValue").asDouble();
                    }
                    if (metricValue == null) {
                        for (String key : new String[]{"Alert Fired reason", "alertFiredReason", "firedReason", "reason"}) {
                            if (additionalProps.has(key)) {
                                String reasonText = additionalProps.path(key).asText("");
                                Double parsed = extractMetricValueFromText(reasonText);
                                if (parsed != null) {
                                    metricValue = parsed;
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            if (metricValue == null && "Fired".equals(monitorCondition)) {
                JsonNode customProps = alertNode.path("properties").path("customProperties");
                if (!customProps.isMissingNode() && !customProps.isNull()) {
                    if (customProps.has("metricValue") && !customProps.path("metricValue").isNull()) {
                        metricValue = customProps.path("metricValue").asDouble();
                    }
                }
            }

            if (metricName == null && alertRule != null && alertRule.contains("/metricAlerts/")) {
                try {
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
                        if (metricName == null) metricName = rule.getMetricName();
                        if (metricNamespace == null) metricNamespace = rule.getMetricNamespace();
                        if (operator == null) operator = rule.getOperator();
                        if (threshold == null) threshold = rule.getThreshold();

                        if (metricValue != null && "Available Memory Bytes".equals(metricName)) {
                            metricValue = metricValue / (1024.0 * 1024.0);
                        }
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
            if (alertName != null && alertName.contains("] ")) {
                alertName = alertName.substring(alertName.indexOf("] ") + 2);
            }

            log.info("Alert {} [{}] - metricName={}, metricValue={}", alertId, monitorCondition, metricName, metricValue);

            return AzureAlert.builder()
                    .vm(vm)
                    .azureAlertId(alertId)
                    .alertName(alertName)
                    .severity(severity)
                    .description(description)
                    .occurredAt(occurredAt)
                    .monitorCondition(monitorCondition)
                    .resolvedAt(resolvedAt)
                    .firedAt(firedAt)
                    .alertRule(alertRule)
                    .metricName(metricName)
                    .metricNamespace(metricNamespace)
                    .metricValue(metricValue)
                    .operator(operator)
                    .threshold(threshold)
                    .build();

        } catch (Exception e) {
            log.warn("Skipping malformed alert: {}", e.getMessage(), e);
            return null;
        }
    }

    private Double extractMetricValueFromText(String text) {
        if (text == null || text.isBlank()) return null;
        Pattern pattern = Pattern.compile("(?i)value\\s+is\\s+([\\d.]+)");
        Matcher matcher = pattern.matcher(text);
        if (matcher.find()) {
            try {
                return Double.parseDouble(matcher.group(1));
            } catch (Exception e) {
                log.warn("Failed to parse metric value from text: {}", text);
            }
        }
        Pattern fallback = Pattern.compile("([\\d]+\\.[\\d]+)");
        Matcher fallbackMatcher = fallback.matcher(text);
        if (fallbackMatcher.find()) {
            try {
                return Double.parseDouble(fallbackMatcher.group(1));
            } catch (Exception e) {}
        }
        return null;
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