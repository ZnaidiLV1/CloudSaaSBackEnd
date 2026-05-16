package org.example.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.example.ai.dto.request.InvoiceRequestDTOs.BatchInvoiceRequestDTO;
import org.example.ai.dto.response.InvoiceResponseDTOs.InvoiceAnalysisResponseDTO;
import org.example.ai.entity.AIInvoiceAnalysis;
import org.example.ai.prompt.InvoiceAnalysisPromptBuilder;
import org.example.ai.repository.AIInvoiceAnalysisRepository;
import org.example.azure.entity.Invoice;
import org.example.azure.repository.InvoiceRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIInvoiceAnalysisService {
    private final InvoiceRepository invoiceRepository;
    private final OpenRouterClient openRouterClient;
    private final AIInvoiceAnalysisRepository analysisRepository;
    private final InvoiceAnalysisPromptBuilder promptBuilder;
    private final ObjectMapper objectMapper;

    private static final DateTimeFormatter MONTH_FORMATTER = DateTimeFormatter.ofPattern("MMMM yyyy");

    private String cleanAiResponse(String aiResponse) {
        if (aiResponse == null || aiResponse.isEmpty()) {
            return "{\"analysis\":{\"summary\":\"No data\",\"yearlyComparison\":{\"change2024to2025\":0,\"projected2026\":0,\"change2025to2026\":0},\"lastTwoMonthsAnalysis\":\"No data\",\"monthlyInsights\":{\"peakMonth\":\"\",\"lowestMonth\":\"\",\"averageMonthly\":0,\"seasonality\":\"\"},\"predictionAnalysis\":\"No prediction\",\"anomalies\":[],\"recommendation\":{\"action\":\"NONE\",\"suggestion\":\"Unable to analyze\"}}}";
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
            return "{\"analysis\":{\"summary\":\"Analysis failed\",\"yearlyComparison\":{\"change2024to2025\":0,\"projected2026\":0,\"change2025to2026\":0},\"lastTwoMonthsAnalysis\":\"No data\",\"monthlyInsights\":{\"peakMonth\":\"\",\"lowestMonth\":\"\",\"averageMonthly\":0,\"seasonality\":\"\"},\"predictionAnalysis\":\"No prediction\",\"anomalies\":[],\"recommendation\":{\"action\":\"NONE\",\"suggestion\":\"Unable to analyze\"}}}";
        }
        return cleaned;
    }

    private Double calculateYearlyTotal(List<Invoice> invoices, int year) {
        return invoices.stream()
                .filter(i -> i.getBillingPeriodStart() != null && i.getBillingPeriodStart().getYear() == year)
                .mapToDouble(Invoice::getTotalAmount)
                .sum();
    }

    private List<BatchInvoiceRequestDTO.MonthlyAmount> getLast12Months(List<Invoice> invoices) {
        List<BatchInvoiceRequestDTO.MonthlyAmount> monthlyAmounts = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime lastCompleteMonth = now.withDayOfMonth(1).minusDays(1);
        LocalDateTime startDate = lastCompleteMonth.minusMonths(11).withDayOfMonth(1);

        for (int i = 0; i < 12; i++) {
            LocalDateTime monthStart = startDate.plusMonths(i);
            String monthName = monthStart.format(MONTH_FORMATTER);

            double total = invoices.stream()
                    .filter(inv -> inv.getBillingPeriodStart() != null)
                    .filter(inv -> inv.getBillingPeriodStart().getYear() == monthStart.getYear()
                            && inv.getBillingPeriodStart().getMonthValue() == monthStart.getMonthValue())
                    .mapToDouble(Invoice::getTotalAmount)
                    .sum();

            if (total > 0 || monthStart.isBefore(lastCompleteMonth)) {
                BatchInvoiceRequestDTO.MonthlyAmount ma = new BatchInvoiceRequestDTO.MonthlyAmount();
                ma.setMonth(monthName);
                ma.setAmount(Math.round(total * 100.0) / 100.0);
                monthlyAmounts.add(ma);
            }
        }
        return monthlyAmounts;
    }

    @Transactional
    public void analyzeInvoices() {
        List<Invoice> allInvoices = invoiceRepository.findAll();

        if (allInvoices.isEmpty()) {
            log.warn("No invoices found");
            return;
        }

        BatchInvoiceRequestDTO request = new BatchInvoiceRequestDTO();

        BatchInvoiceRequestDTO.YearlyTotals yearlyTotals = new BatchInvoiceRequestDTO.YearlyTotals();
        yearlyTotals.setYear2024(calculateYearlyTotal(allInvoices, 2024));
        yearlyTotals.setYear2025(calculateYearlyTotal(allInvoices, 2025));
        yearlyTotals.setYear2026(calculateYearlyTotal(allInvoices, 2026));
        request.setYearlyTotals(yearlyTotals);

        List<BatchInvoiceRequestDTO.MonthlyAmount> last12Months = getLast12Months(allInvoices);
        request.setLast12Months(last12Months);

        try {
            String prompt = promptBuilder.buildPrompt(request);

            String aiResponse = openRouterClient.sendMessage(prompt);

            String cleanedResponse = cleanAiResponse(aiResponse);
            InvoiceAnalysisResponseDTO response = objectMapper.readValue(cleanedResponse, InvoiceAnalysisResponseDTO.class);

            analysisRepository.deleteAllRecords();
            saveAnalysisToDatabase(response);
        } catch (Exception e) {
            log.error("Invoice AI analysis failed: {}", e.getMessage());
        }
    }

    private void saveAnalysisToDatabase(InvoiceAnalysisResponseDTO response) {
        boolean hasAnomalies = response.getAnalysis().getAnomalies() != null && !response.getAnalysis().getAnomalies().isEmpty();
        String anomaliesDetails = hasAnomalies ? String.join("; ", response.getAnalysis().getAnomalies()) : null;

        AIInvoiceAnalysis entity = AIInvoiceAnalysis.builder()
                .summary(response.getAnalysis().getSummary())
                .year2024To2025Change(response.getAnalysis().getYearlyComparison().getChange2024to2025())
                .projected2026Total(response.getAnalysis().getYearlyComparison().getProjected2026())
                .year2025To2026ProjectedChange(response.getAnalysis().getYearlyComparison().getChange2025to2026())
                .lastTwoMonthsAnalysis(response.getAnalysis().getLastTwoMonthsAnalysis())
                .peakMonthName(response.getAnalysis().getMonthlyInsights().getPeakMonth())
                .lowestMonthName(response.getAnalysis().getMonthlyInsights().getLowestMonth())
                .averageMonthlyCost(response.getAnalysis().getMonthlyInsights().getAverageMonthly())
                .seasonality(response.getAnalysis().getMonthlyInsights().getSeasonality())
                .predictionAnalysis(response.getAnalysis().getPredictionAnalysis())
                .anomaliesDetected(hasAnomalies)
                .anomaliesDetails(anomaliesDetails)
                .recommendationAction(response.getAnalysis().getRecommendation().getAction())
                .recommendationSuggestion(response.getAnalysis().getRecommendation().getSuggestion())
                .createdAt(LocalDateTime.now())
                .build();

        analysisRepository.save(entity);
        log.info("Saved invoice analysis");
    }

    public AIInvoiceAnalysis getLatestInvoiceAnalysis() {
        List<AIInvoiceAnalysis> analyses = analysisRepository.findAll();
        if (analyses.isEmpty()) {
            return null;
        }
        return analyses.get(analyses.size() - 1);
    }
}