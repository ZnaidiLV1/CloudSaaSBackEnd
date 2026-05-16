package org.example.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.example.ai.dto.request.VmCostRequestDTOs.BatchVmCostRequestDTO;
import org.example.ai.dto.response.VmCostResponseDTOs.VmCostAnalysisResponseDTO;
import org.example.ai.entity.AIVmCostAnalysis;
import org.example.ai.prompt.VmCostAnalysisPromptBuilder;
import org.example.ai.repository.AIVmCostAnalysisRepository;
import org.example.azure.entity.MonthlyVmCost;
import org.example.azure.entity.Vm;
import org.example.azure.repository.MonthlyVmCostRepository;
import org.example.azure.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIVmCostAnalysisService {
    private final VmRepository vmRepository;
    private final MonthlyVmCostRepository monthlyVmCostRepository;
    private final OpenRouterClient openRouterClient;
    private final AIVmCostAnalysisRepository analysisRepository;
    private final VmCostAnalysisPromptBuilder promptBuilder;
    private final ObjectMapper objectMapper;

    private static final DateTimeFormatter MONTH_FORMATTER = DateTimeFormatter.ofPattern("MMMM yyyy");

    private String cleanAiResponse(String aiResponse) {
        if (aiResponse == null || aiResponse.isEmpty()) {
            return "{\"analyses\":[],\"overallSummary\":\"No data available\"}";
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
            return "{\"analyses\":[],\"overallSummary\":\"Analysis failed\"}";
        }
        return cleaned;
    }

    private List<BatchVmCostRequestDTO.MonthlyCostDetail> getLast12MonthsForVm(Long vmId) {
        List<BatchVmCostRequestDTO.MonthlyCostDetail> monthlyDetails = new ArrayList<>();
        List<MonthlyVmCost> costs = monthlyVmCostRepository.findByVmIdOrderByYearMonthDesc(vmId);

        if (costs.isEmpty()) {
            return monthlyDetails;
        }

        costs.sort(Comparator.comparingInt(c -> c.getYear() * 12 + c.getMonth()));
        int totalMonths = costs.size();
        int startIndex = Math.max(0, totalMonths - 12);

        for (int i = startIndex; i < totalMonths; i++) {
            MonthlyVmCost cost = costs.get(i);
            LocalDateTime monthDate = LocalDateTime.of(cost.getYear(), cost.getMonth(), 1, 0, 0);
            String monthName = monthDate.format(MONTH_FORMATTER);

            BatchVmCostRequestDTO.MonthlyCostDetail detail = new BatchVmCostRequestDTO.MonthlyCostDetail();
            detail.setMonth(monthName);
            detail.setDirectCost(Math.round(cost.getDirectCost().doubleValue() * 100.0) / 100.0);
            detail.setReservationCost(Math.round(cost.getReservationCost().doubleValue() * 100.0) / 100.0);
            detail.setSharedCost(Math.round(cost.getSharedCost().doubleValue() * 100.0) / 100.0);
            detail.setTotalCost(Math.round(cost.getTotalCost().doubleValue() * 100.0) / 100.0);
            monthlyDetails.add(detail);
        }
        return monthlyDetails;
    }

    @Transactional
    public void analyzeAllVmsCosts() {
        List<Vm> allVms = vmRepository.findAll();
        log.info("=== STARTING VM COST ANALYSIS FOR {} VMs ===", allVms.size());

        int successCount = 0;
        int failCount = 0;
        int skipCount = 0;

        for (int i = 0; i < allVms.size(); i++) {
            Vm vm = allVms.get(i);
            log.info("Processing VM {}/{}: {} (ID: {})", i + 1, allVms.size(), vm.getName(), vm.getId());

            boolean success = analyzeSingleVm(vm);
            if (success) {
                successCount++;
            } else {
                failCount++;
            }

            if (i < allVms.size() - 1) {
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    log.warn("Sleep interrupted");
                }
            }
        }

        log.info("=== VM COST ANALYSIS COMPLETED ===");
        log.info("Success: {}, Failed: {}, Skipped: {}", successCount, failCount, skipCount);
    }

    private boolean analyzeSingleVm(Vm vm) {
        List<BatchVmCostRequestDTO.MonthlyCostDetail> monthlyDetails = getLast12MonthsForVm(vm.getId());

        if (monthlyDetails.isEmpty()) {
            log.warn("VM {} - No monthly cost data found, skipping", vm.getName());
            return false;
        }

        if (monthlyDetails.size() < 2) {
            log.warn("VM {} - Only {} months of data (need at least 2), skipping", vm.getName(), monthlyDetails.size());
            return false;
        }

        log.info("VM {} - Found {} months of data ({} to {})",
                vm.getName(), monthlyDetails.size(),
                monthlyDetails.get(0).getMonth(),
                monthlyDetails.get(monthlyDetails.size() - 1).getMonth());

        BatchVmCostRequestDTO request = new BatchVmCostRequestDTO();
        List<BatchVmCostRequestDTO.VmCostData> vmCostDataList = new ArrayList<>();

        BatchVmCostRequestDTO.VmCostData vmData = new BatchVmCostRequestDTO.VmCostData();
        vmData.setVmId(vm.getId());
        vmData.setVmName(vm.getName());
        vmData.setMonths(monthlyDetails);
        vmCostDataList.add(vmData);
        request.setVms(vmCostDataList);

        try {
            String prompt = promptBuilder.buildPrompt(request);
            log.info("VM {} - Prompt length: {} characters", vm.getName(), prompt.length());

            long startTime = System.currentTimeMillis();
            String aiResponse = openRouterClient.sendMessage(prompt);
            long endTime = System.currentTimeMillis();
            log.info("VM {} - AI response received in {} ms", vm.getName(), (endTime - startTime));

            if (aiResponse == null || aiResponse.isEmpty()) {
                log.error("VM {} - No response from AI", vm.getName());
                return false;
            }

            log.info("VM {} - AI response length: {} characters", vm.getName(), aiResponse.length());

            String cleanedResponse = cleanAiResponse(aiResponse);
            VmCostAnalysisResponseDTO response = objectMapper.readValue(cleanedResponse, VmCostAnalysisResponseDTO.class);

            if (response.getAnalyses() == null || response.getAnalyses().isEmpty()) {
                log.error("VM {} - No analysis in response", vm.getName());
                return false;
            }

            VmCostAnalysisResponseDTO.VmAnalysis analysis = response.getAnalyses().get(0);
            analysisRepository.deleteByVmId(vm.getId());
            saveAnalysisToDatabase(analysis);
            log.info("VM {} - Analysis saved successfully", vm.getName());
            return true;

        } catch (Exception e) {
            log.error("VM {} - Analysis failed: {}", vm.getName(), e.getMessage(), e);
            return false;
        }
    }

    private void saveAnalysisToDatabase(VmCostAnalysisResponseDTO.VmAnalysis analysis) {
        AIVmCostAnalysis entity = AIVmCostAnalysis.builder()
                .vmId(analysis.getVmId())
                .vmName(analysis.getVmName())
                .summary(analysis.getSummary() != null ? analysis.getSummary() : "")
                .previousMonth(analysis.getMonthlyComparison() != null ? analysis.getMonthlyComparison().getPreviousMonth() : null)
                .previousMonthTotal(null)
                .currentMonth(analysis.getMonthlyComparison() != null ? analysis.getMonthlyComparison().getCurrentMonth() : null)
                .currentMonthTotal(null)
                .monthOverMonthChange(analysis.getMonthlyComparison() != null ? analysis.getMonthlyComparison().getChangePercent() : null)
                .monthOverMonthDirection(analysis.getMonthlyComparison() != null ? analysis.getMonthlyComparison().getDirection() : null)
                .changeCause(analysis.getMonthlyComparison() != null ? analysis.getMonthlyComparison().getCause() : null)
                .averageMonthly(analysis.getStatistics() != null ? analysis.getStatistics().getAverageMonthly() : null)
                .peakMonth(analysis.getStatistics() != null ? analysis.getStatistics().getPeakMonth() : null)
                .lowestMonth(analysis.getStatistics() != null ? analysis.getStatistics().getLowestMonth() : null)
                .trend(analysis.getStatistics() != null ? analysis.getStatistics().getTrend() : null)
                .reservationUtilization(analysis.getStatistics() != null ? analysis.getStatistics().getReservationUtilization() : null)
                .reservationSavingsPercent(analysis.getCostEfficiency() != null ? analysis.getCostEfficiency().getReservationSavingsPercent() : null)
                .sharedCostPercent(analysis.getCostEfficiency() != null ? analysis.getCostEfficiency().getSharedCostPercentOfTotal() : null)
                .costEfficiencyAction(analysis.getCostEfficiency() != null ? analysis.getCostEfficiency().getRecommendedAction() : null)
                .predictedNextMonth(analysis.getPrediction() != null ? analysis.getPrediction().getNextMonth() : null)
                .predictedTotal(analysis.getPrediction() != null ? analysis.getPrediction().getPredictedTotal() : null)
                .predictedDirect(analysis.getPrediction() != null ? analysis.getPrediction().getPredictedDirect() : null)
                .predictedReservation(analysis.getPrediction() != null ? analysis.getPrediction().getPredictedReservation() : null)
                .predictedShared(analysis.getPrediction() != null ? analysis.getPrediction().getPredictedShared() : null)
                .predictedChangePercent(analysis.getPrediction() != null ? analysis.getPrediction().getChangePercent() : null)
                .predictedDirection(analysis.getPrediction() != null ? analysis.getPrediction().getDirection() : null)
                .predictionConfidence(analysis.getPrediction() != null ? analysis.getPrediction().getConfidence() : null)
                .predictionExplanation(analysis.getPrediction() != null ? analysis.getPrediction().getExplanation() : null)
                .recommendationAction(analysis.getRecommendation() != null ? analysis.getRecommendation().getAction() : "NONE")
                .recommendationSuggestion(analysis.getRecommendation() != null ? analysis.getRecommendation().getSuggestion() : "")
                .createdAt(LocalDateTime.now())
                .build();

        analysisRepository.save(entity);
    }

    public AIVmCostAnalysis getLatestVmCostAnalysis(Long vmId) {
        return analysisRepository.findTopByVmIdOrderByCreatedAtDesc(vmId).orElse(null);
    }

    public List<AIVmCostAnalysis> getAllLatestVmCostAnalyses() {
        return analysisRepository.findAllByOrderByVmNameAsc();
    }
}