package org.example.ai.prompt;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.dto.request.MonthlyReportRequestDTOs.MonthlyReportRequestDTO;
import org.springframework.stereotype.Component;
import java.nio.file.Files;
import java.nio.file.Paths;

@Component
@RequiredArgsConstructor
@Slf4j
public class MonthlyReportPromptBuilder {
    private final ObjectMapper objectMapper;
    private String cachedTemplate;

    private String loadTemplate() {
        if (cachedTemplate != null) {
            return cachedTemplate;
        }
        try {
            String path = "src/main/java/org/example/ai/prompt/templates/monthly_report.txt";
            cachedTemplate = Files.readString(Paths.get(path));
            return cachedTemplate;
        } catch (Exception e) {
            log.warn("Failed to load monthly report template, using default", e);
            return getDefaultTemplate();
        }
    }

    private String getDefaultTemplate() {
        return "Return ONLY valid JSON. NO explanations.\n\nREPORT MONTH: {reportMonth}\nREPORT YEAR: {reportYear}\n\nDATA:\n{requestJson}";
    }

    public String buildPrompt(MonthlyReportRequestDTO request) throws Exception {
        String template = loadTemplate();
        template = template.replace("{reportMonth}", String.valueOf(request.getReportMonth()));
        template = template.replace("{reportYear}", String.valueOf(request.getReportYear()));
        String requestJson = objectMapper.writeValueAsString(request);
        template = template.replace("{requestJson}", requestJson);
        return template;
    }
}