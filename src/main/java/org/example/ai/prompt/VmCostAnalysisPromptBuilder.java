package org.example.ai.prompt;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.dto.request.VmCostRequestDTOs.BatchVmCostRequestDTO;
import org.springframework.stereotype.Component;
import java.nio.file.Files;
import java.nio.file.Paths;

@Component
@RequiredArgsConstructor
@Slf4j
public class VmCostAnalysisPromptBuilder {
    private final ObjectMapper objectMapper;
    private String cachedTemplate;

    private String loadTemplate() {
        if (cachedTemplate != null) {
            return cachedTemplate;
        }
        try {
            String path = "src/main/java/org/example/ai/prompt/templates/vm_cost_analysis.txt";
            cachedTemplate = Files.readString(Paths.get(path));
            return cachedTemplate;
        } catch (Exception e) {
            log.warn("Failed to load VM cost template, using default", e);
            return getDefaultTemplate();
        }
    }

    private String getDefaultTemplate() {
        return "Return ONLY valid JSON. NO explanations.\n\n{\"analyses\":[],\"overallSummary\":\"\"}\n\nVM Data:\n{vms_json}";
    }

    public String buildPrompt(BatchVmCostRequestDTO request) throws Exception {
        String template = loadTemplate();
        String vmsJson = objectMapper.writeValueAsString(request.getVms());
        return template.replace("{vms_json}", vmsJson);
    }
}