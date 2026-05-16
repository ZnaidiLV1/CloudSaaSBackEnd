package org.example.ai.prompt;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.dto.request.AlertRequestDTOs.BatchAlertRequestDTO;
import org.springframework.stereotype.Component;
import java.nio.file.Files;
import java.nio.file.Paths;

@Component
@RequiredArgsConstructor
@Slf4j
public class AlertAnalysisPromptBuilder {
    private final ObjectMapper objectMapper;
    private String cachedTemplate;

    private String loadTemplate() {
        if (cachedTemplate != null) {
            return cachedTemplate;
        }
        try {
            String path = "src/main/java/org/example/ai/prompt/templates/alert_analysis.txt";
            cachedTemplate = Files.readString(Paths.get(path));
            return cachedTemplate;
        } catch (Exception e) {
            log.warn("Failed to load alert template, using default", e);
            return getDefaultTemplate();
        }
    }

    private String getDefaultTemplate() {
        return "You are an Azure VM alert pattern analysis expert. Analyze each VM's alerts from the last 30 days and return JSON.\n\nVM Data:\n{vms_json}\n\nFor each VM analyze alert patterns, predictions, anomalies, and suggestions.\n\nReturn ONLY valid JSON.\n\n{\n  \"analyses\": [\n    {\n      \"vmId\": 1,\n      \"vmName\": \"example\",\n      \"alertPattern\": {\"hasPattern\": true, \"description\": \"Daily low RAM alerts\", \"frequencyPerDay\": \"4-6 times\", \"averageDurationMinutes\": 65, \"peakHour\": 17, \"peakDay\": \"MONDAY\"},\n      \"prediction\": {\"nextExpectedAlert\": \"Today at 4:35 PM\", \"trend\": \"STABLE\"},\n      \"anomaly\": {\"detected\": false, \"details\": null},\n      \"suggestion\": {\"action\": \"INVESTIGATE\", \"suggestion\": \"Review process during peak hours\"}\n    }\n  ]\n}";
    }

    public String buildPrompt(BatchAlertRequestDTO request) throws Exception {
        String template = loadTemplate();
        String vmsJson = objectMapper.writeValueAsString(request.getVms());
        return template.replace("{vms_json}", vmsJson);
    }
}