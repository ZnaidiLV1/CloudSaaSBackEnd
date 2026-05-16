package org.example.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.example.ai.dto.request.CostRequestDTOs.BatchCostRequestDTO;
import org.example.ai.dto.response.CostResponseDTOs.CostAnalysisResponseDTO;
import org.example.ai.entity.AICostAnalysis;
import org.example.ai.prompt.CostAnalysisPromptBuilder;
import org.example.ai.repository.AICostAnalysisRepository;
import org.example.azure.entity.MonthlyCost;
import org.example.azure.repository.MonthlyCostRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AICostAnalysisService {
    private final MonthlyCostRepository monthlyCostRepository;
    private final OpenRouterClient openRouterClient;
    private final AICostAnalysisRepository analysisRepository;
    private final CostAnalysisPromptBuilder promptBuilder;
    private final ObjectMapper objectMapper;

    private static final DateTimeFormatter MONTH_FORMATTER = DateTimeFormatter.ofPattern("MMMM yyyy");
    private static final double THRESHOLD = 10.0;

    private String cleanAiResponse(String aiResponse) {
        if (aiResponse == null || aiResponse.isEmpty()) {
            return "{\"analysis\":{\"summary\":\"No data\",\"monthlyComparison\":{\"previousMonth\":\"\",\"previousMonthTotal\":0,\"currentMonth\":\"\",\"currentMonthTotal\":0,\"changePercent\":0,\"direction\":\"\",\"mainDriver\":\"\"},\"serviceBreakdown\":{\"averageMonthly\":[],\"topDriver\":\"\",\"fastestGrowing\":\"\"},\"anomalies\":[],\"prediction\":{\"nextMonth\":\"\",\"predictedTotal\":0,\"changePercent\":0,\"direction\":\"\",\"confidence\":\"\"},\"recommendation\":{\"action\":\"NONE\",\"suggestion\":\"Unable to analyze\"}}}";
        }
        String cleaned = aiResponse.trim();
        if (cleaned.startsWith("```json")) {
            cleaned = cleaned.substring(7);
        }
        if (cleaned.startsWith("```")) {
            cleaned = cleaned.substring(3);
        }
        if (cleaned.endsWith("```")) {
            cleaned = cleaned.substring(0, cleaned.length() - 3);
        }
        cleaned = cleaned.trim();
        if (!cleaned.startsWith("{")) {
            log.warn("AI returned non-JSON response");
            return "{\"analysis\":{\"summary\":\"Analysis failed\",\"monthlyComparison\":{\"previousMonth\":\"\",\"previousMonthTotal\":0,\"currentMonth\":\"\",\"currentMonthTotal\":0,\"changePercent\":0,\"direction\":\"\",\"mainDriver\":\"\"},\"serviceBreakdown\":{\"averageMonthly\":[],\"topDriver\":\"\",\"fastestGrowing\":\"\"},\"anomalies\":[],\"prediction\":{\"nextMonth\":\"\",\"predictedTotal\":0,\"changePercent\":0,\"direction\":\"\",\"confidence\":\"\"},\"recommendation\":{\"action\":\"NONE\",\"suggestion\":\"Unable to analyze\"}}}";
        }
        return cleaned;
    }

    private List<BatchCostRequestDTO.MonthlyCostData> getLast12MonthsData() {
        List<BatchCostRequestDTO.MonthlyCostData> monthlyDataList = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime lastCompleteMonth = now.withDayOfMonth(1).minusDays(1);
        LocalDateTime startDate = lastCompleteMonth.minusMonths(11).withDayOfMonth(1);

        for (int i = 0; i < 12; i++) {
            LocalDateTime monthStart = startDate.plusMonths(i);
            int year = monthStart.getYear();
            int month = monthStart.getMonthValue();

            List<MonthlyCost> costs = monthlyCostRepository.findByMonthAndYear(month, year);

            if (costs.isEmpty()) {
                continue;
            }

            Map<String, Double> serviceCostMap = new HashMap<>();
            double totalCost = 0.0;

            for (MonthlyCost cost : costs) {
                String serviceName = cost.getServiceName();
                double costValue = cost.getCost().doubleValue();
                serviceCostMap.merge(serviceName, costValue, Double::sum);
                totalCost += costValue;
            }

            List<BatchCostRequestDTO.ServiceCost> services = new ArrayList<>();
            for (Map.Entry<String, Double> entry : serviceCostMap.entrySet()) {
                if (entry.getValue() >= THRESHOLD) {
                    BatchCostRequestDTO.ServiceCost sc = new BatchCostRequestDTO.ServiceCost();
                    sc.setServiceName(entry.getKey());
                    sc.setCost(Math.round(entry.getValue() * 100.0) / 100.0);
                    services.add(sc);
                }
            }

            services.sort((a, b) -> Double.compare(b.getCost(), a.getCost()));

            BatchCostRequestDTO.MonthlyCostData monthData = new BatchCostRequestDTO.MonthlyCostData();
            monthData.setMonth(monthStart.format(MONTH_FORMATTER));
            monthData.setYear(year);
            monthData.setTotalCost(Math.round(totalCost * 100.0) / 100.0);
            monthData.setServices(services);
            monthlyDataList.add(monthData);
        }

        return monthlyDataList;
    }

    @Transactional
    public void analyzeCosts() {
        List<BatchCostRequestDTO.MonthlyCostData> monthlyData = getLast12MonthsData();

        if (monthlyData.isEmpty() || monthlyData.size() < 2) {
            log.warn("Insufficient cost data for analysis");
            return;
        }

        BatchCostRequestDTO request = new BatchCostRequestDTO();
        request.setMonths(monthlyData);

        log.info("=== COST ANALYSIS REQUEST ===");
        for (BatchCostRequestDTO.MonthlyCostData md : monthlyData) {
            log.info("Month: {}, Total: {}, Services: {}", md.getMonth(), md.getTotalCost(), md.getServices().size());
        }
        log.info("=== END REQUEST ===");

        try {
            String prompt = promptBuilder.buildPrompt(request);
            String aiResponse = openRouterClient.sendMessage(prompt);
            String cleanedResponse = cleanAiResponse(aiResponse);
            CostAnalysisResponseDTO response = objectMapper.readValue(cleanedResponse, CostAnalysisResponseDTO.class);

            analysisRepository.deleteAllRecords();
            saveAnalysisToDatabase(response, monthlyData);
        } catch (Exception e) {
            log.error("Cost AI analysis failed: {}", e.getMessage());
        }
    }

    private void saveAnalysisToDatabase(CostAnalysisResponseDTO response, List<BatchCostRequestDTO.MonthlyCostData> monthlyData) {
        String serviceBreakdownJson = null;
        String anomaliesJson = null;

        try {
            if (response.getAnalysis().getServiceBreakdown() != null && response.getAnalysis().getServiceBreakdown().getAverageMonthly() != null) {
                serviceBreakdownJson = objectMapper.writeValueAsString(response.getAnalysis().getServiceBreakdown().getAverageMonthly());
            }
            if (response.getAnalysis().getAnomalies() != null && !response.getAnalysis().getAnomalies().isEmpty()) {
                anomaliesJson = objectMapper.writeValueAsString(response.getAnalysis().getAnomalies());
            }
        } catch (Exception e) {
            log.warn("Failed to serialize JSON fields: {}", e.getMessage());
        }

        AICostAnalysis entity = AICostAnalysis.builder()
                .summary(response.getAnalysis().getSummary())
                .previousMonth(response.getAnalysis().getMonthlyComparison().getPreviousMonth())
                .previousMonthTotal(response.getAnalysis().getMonthlyComparison().getPreviousMonthTotal())
                .currentMonth(response.getAnalysis().getMonthlyComparison().getCurrentMonth())
                .currentMonthTotal(response.getAnalysis().getMonthlyComparison().getCurrentMonthTotal())
                .monthOverMonthChange(response.getAnalysis().getMonthlyComparison().getChangePercent())
                .monthOverMonthDirection(response.getAnalysis().getMonthlyComparison().getDirection())
                .mainDriverService(response.getAnalysis().getMonthlyComparison().getMainDriver())
                .serviceBreakdownJson(serviceBreakdownJson)
                .topDriver(response.getAnalysis().getServiceBreakdown().getTopDriver())
                .fastestGrowing(response.getAnalysis().getServiceBreakdown().getFastestGrowing())
                .anomaliesJson(anomaliesJson)
                .predictedNextMonth(response.getAnalysis().getPrediction().getNextMonth())
                .predictedTotal(response.getAnalysis().getPrediction().getPredictedTotal())
                .predictedChangePercent(response.getAnalysis().getPrediction().getChangePercent())
                .predictedDirection(response.getAnalysis().getPrediction().getDirection())
                .predictionConfidence(response.getAnalysis().getPrediction().getConfidence())
                .recommendationAction(response.getAnalysis().getRecommendation().getAction())
                .recommendationSuggestion(response.getAnalysis().getRecommendation().getSuggestion())
                .createdAt(LocalDateTime.now())
                .build();

        analysisRepository.save(entity);
        log.info("Saved cost analysis");
    }

    public AICostAnalysis getLatestCostAnalysis() {
        List<AICostAnalysis> analyses = analysisRepository.findAll();
        if (analyses.isEmpty()) {
            return null;
        }
        return analyses.get(analyses.size() - 1);
    }
}