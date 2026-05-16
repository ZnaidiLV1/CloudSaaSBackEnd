package org.example.ai.prompt;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.dto.request.InvoiceRequestDTOs.BatchInvoiceRequestDTO;
import org.springframework.stereotype.Component;
import java.nio.file.Files;
import java.nio.file.Paths;

@Component
@RequiredArgsConstructor
@Slf4j
public class InvoiceAnalysisPromptBuilder {
    private final ObjectMapper objectMapper;
    private String cachedTemplate;

    private String loadTemplate() {
        if (cachedTemplate != null) {
            return cachedTemplate;
        }
        try {
            String path = "src/main/java/org/example/ai/prompt/templates/invoice_analysis.txt";
            cachedTemplate = Files.readString(Paths.get(path));
            return cachedTemplate;
        } catch (Exception e) {
            log.warn("Failed to load invoice template, using default", e);
            return getDefaultTemplate();
        }
    }

    private String getDefaultTemplate() {
        return "Return ONLY valid JSON. NO explanations.\n\n{\"analysis\":{\"summary\":\"Cost summary\",\"yearlyComparison\":{\"change2024to2025\":0,\"projected2026\":0,\"change2025to2026\":0},\"lastTwoMonthsAnalysis\":\"Change between months\",\"monthlyInsights\":{\"peakMonth\":\"\",\"lowestMonth\":\"\",\"averageMonthly\":0,\"seasonality\":\"\"},\"predictionAnalysis\":\"Prediction\",\"anomalies\":[],\"recommendation\":{\"action\":\"\",\"suggestion\":\"\"}}}\n\nYearly Totals - 2024: ${year2024}, 2025: ${year2025}, 2026: ${year2026}\nLast 12 Months: {months_json}";
    }

    public String buildPrompt(BatchInvoiceRequestDTO request) throws Exception {
        String template = loadTemplate();
        template = template.replace("${year2024}", String.valueOf(request.getYearlyTotals().getYear2024()));
        template = template.replace("${year2025}", String.valueOf(request.getYearlyTotals().getYear2025()));
        template = template.replace("${year2026}", String.valueOf(request.getYearlyTotals().getYear2026()));
        String monthsJson = objectMapper.writeValueAsString(request.getLast12Months());
        template = template.replace("{months_json}", monthsJson);
        return template;
    }
}