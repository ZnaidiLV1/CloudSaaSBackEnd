package org.example.ai.prompt;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.dto.request.DiskAIRequestDTOs.BatchDiskRequestDTO;
import org.springframework.stereotype.Component;
import java.nio.file.Files;
import java.nio.file.Paths;

@Component
@RequiredArgsConstructor
@Slf4j
public class DiskAnalysisPromptBuilder {

    private final ObjectMapper objectMapper;
    private String cachedTemplate;

    private String loadTemplate() {
        if (cachedTemplate != null) {
            return cachedTemplate;
        }
        try {
            String path = "src/main/java/org/example/ai/prompt/templates/disk_analysis.txt";
            cachedTemplate = Files.readString(Paths.get(path));
            return cachedTemplate;
        } catch (Exception e) {
            log.warn("Failed to load template file, using default template", e);
            return getDefaultTemplate();
        }
    }

    private String getDefaultTemplate() {
        return "You are an Azure VM disk capacity expert. Analyze each VM and return JSON.\n\n" +
                "VM Data:\n{vms_json}\n\n" +
                "For each VM, calculate:\n" +
                "1. PREDICTION: days until 90% full (formula: (totalGB * 0.9 - (totalGB - freeGB)) / (avgDailyWriteMB / 1024)), " +
                "riskLevel: CRITICAL(<7 days), HIGH(<30), MEDIUM(<90), LOW(>90), recommendation\n" +
                "2. ANOMALY: detected if peakDailyWriteMB > 3x avgDailyWriteMB, details, possibleCauses\n" +
                "3. OPTIMIZATION: suggestion based on freePercent and writeTrend, action (RESIZE_DOWN, RESIZE_UP, CLEANUP, CHANGE_TIER, NONE)\n\n" +
                "Return ONLY valid JSON. No explanation.\n\n" +
                "{\n" +
                "  \"analyses\": [\n" +
                "    {\n" +
                "      \"vmId\": 1,\n" +
                "      \"vmName\": \"example\",\n" +
                "      \"prediction\": {\"daysUntilFull\": 18, \"riskLevel\": \"HIGH\", \"recommendation\": \"Increase disk\"},\n" +
                "      \"anomaly\": {\"detected\": true, \"details\": \"Spike detected\", \"possibleCauses\": \"Update\"},\n" +
                "      \"optimization\": {\"suggestion\": \"Resize down\", \"action\": \"RESIZE_DOWN\"}\n" +
                "    }\n" +
                "  ]\n" +
                "}";
    }

    public String buildPrompt(BatchDiskRequestDTO request) throws Exception {
        String template = loadTemplate();
        String vmsJson = objectMapper.writeValueAsString(request.getVms());
        return template.replace("{vms_json}", vmsJson);
    }
}