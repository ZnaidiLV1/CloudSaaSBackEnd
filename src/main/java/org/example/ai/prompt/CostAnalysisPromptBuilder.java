package org.example.ai.prompt;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.dto.request.CostRequestDTOs.BatchCostRequestDTO;
import org.springframework.stereotype.Component;
import java.nio.file.Files;
import java.nio.file.Paths;

@Component
@RequiredArgsConstructor
@Slf4j
public class CostAnalysisPromptBuilder {
    private final ObjectMapper objectMapper;
    private String cachedTemplate;

    private String loadTemplate() {
        if (cachedTemplate != null) {
            return cachedTemplate;
        }
        try {
            String path = "src/main/java/org/example/ai/prompt/templates/cost_analysis.txt";
            cachedTemplate = Files.readString(Paths.get(path));
            return cachedTemplate;
        } catch (Exception e) {
            log.warn("Failed to load cost template, using default", e);
            return getDefaultTemplate();
        }
    }

    private String getDefaultTemplate() {
        return "Return ONLY valid JSON. NO explanations.\n\n{\"analysis\":{\"summary\":\"\",\"monthlyComparison\":{\"previousMonth\":\"\",\"previousMonthTotal\":0,\"currentMonth\":\"\",\"currentMonthTotal\":0,\"changePercent\":0,\"direction\":\"\",\"mainDriver\":\"\"},\"serviceBreakdown\":{\"averageMonthly\":[],\"topDriver\":\"\",\"fastestGrowing\":\"\"},\"anomalies\":[],\"prediction\":{\"nextMonth\":\"\",\"predictedTotal\":0,\"changePercent\":0,\"direction\":\"\",\"confidence\":\"\"},\"recommendation\":{\"action\":\"\",\"suggestion\":\"\"}}}\n\nMonthly Data:\n{months_json}";
    }

    public String buildPrompt(BatchCostRequestDTO request) throws Exception {
        String template = loadTemplate();
        String monthsJson = objectMapper.writeValueAsString(request.getMonths());
        return template.replace("{months_json}", monthsJson);
    }
}