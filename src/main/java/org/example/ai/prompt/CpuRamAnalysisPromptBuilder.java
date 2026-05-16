package org.example.ai.prompt;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.dto.request.RamCpuAIRequestsDTOs.BatchCpuRamRequestDTO;
import org.springframework.stereotype.Component;
import java.nio.file.Files;
import java.nio.file.Paths;

@Component
@RequiredArgsConstructor
@Slf4j
public class CpuRamAnalysisPromptBuilder {
    private final ObjectMapper objectMapper;
    private String cachedTemplate;

    private String loadTemplate() {
        if (cachedTemplate != null) {
            return cachedTemplate;
        }
        try {
            String path = "src/main/java/org/example/ai/prompt/templates/cpu_ram_analysis.txt";
            cachedTemplate = Files.readString(Paths.get(path));
            return cachedTemplate;
        } catch (Exception e) {
            log.warn("Failed to load CPU RAM template, using default", e);
            return getDefaultTemplate();
        }
    }

    private String getDefaultTemplate() {
        return "You are an Azure VM CPU and RAM pattern analysis expert. Analyze each VM and return JSON.\n\nVM Data:\n{vms_json}\n\nFor each VM analyze daily max CPU and max RAM data over past month.\n\nReturn ONLY valid JSON.\n\n{\n  \"analyses\": [\n    {\n      \"vmId\": 1,\n      \"vmName\": \"example\",\n      \"cpuPattern\": {\"hasPattern\": true, \"description\": \"Peaks Monday 9 AM\", \"peakDay\": \"MONDAY\", \"peakHour\": 9, \"severity\": \"LOW\"},\n      \"ramPattern\": {\"hasPattern\": false, \"description\": \"Random spikes\", \"severity\": \"MEDIUM\"},\n      \"anomaly\": {\"detected\": false, \"details\": null},\n      \"recommendation\": {\"action\": \"NONE\", \"suggestion\": \"Normal pattern\"}\n    }\n  ]\n}";
    }

    public String buildPrompt(BatchCpuRamRequestDTO request) throws Exception {
        String template = loadTemplate();
        String vmsJson = objectMapper.writeValueAsString(request.getVms());
        return template.replace("{vms_json}", vmsJson);
    }
}