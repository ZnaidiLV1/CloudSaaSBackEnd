package org.example.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.example.ai.dto.request.DiskAIRequestDTOs.BatchDiskRequestDTO;
import org.example.ai.dto.response.DiskAIResponseDTOs.DiskAnalysisResponseDTO;
import org.example.ai.entity.AIDiskAnalysis;
import org.example.ai.prompt.DiskAnalysisPromptBuilder;
import org.example.ai.repository.AIDiskAnalysisRepository;
import org.example.azure.entity.PerformanceMetric;
import org.example.azure.entity.Vm;
import org.example.azure.repository.PerformanceMetricRepository;
import org.example.azure.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIDiskAnalysisService {

    private final VmRepository vmRepository;
    private final PerformanceMetricRepository metricRepository;
    private final OpenRouterClient openRouterClient;
    private final AIDiskAnalysisRepository analysisRepository;
    private final DiskAnalysisPromptBuilder promptBuilder;
    private final ObjectMapper objectMapper;

    private double calculateTotalGB(double freeMB, double freePercent) {
        double totalMB = (freeMB / freePercent) * 100;
        return totalMB / 1024;
    }

    private double calculateFreeGB(double freeMB) {
        return freeMB / 1024;
    }

    private List<Double> getDailyWritesMB(List<PerformanceMetric> metrics) {
        Map<LocalDateTime, Double> dailyMap = new HashMap<>();
        for (PerformanceMetric metric : metrics) {
            if (metric.getDiskWrite() != null) {
                LocalDateTime date = metric.getSavedAt();
                dailyMap.merge(date, metric.getDiskWrite(), Double::sum);
            }
        }
        return new ArrayList<>(dailyMap.values());
    }

    private double calculateAverage(List<Double> values) {
        return values.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
    }

    private double calculatePeak(List<Double> values) {
        return values.stream().mapToDouble(Double::doubleValue).max().orElse(0.0);
    }

    private String calculateTrend(List<Double> values) {
        if (values.size() < 14) return "STABLE";
        double firstWeekAvg = calculateAverage(values.subList(0, 7));
        double lastWeekAvg = calculateAverage(values.subList(values.size() - 7, values.size()));
        if (lastWeekAvg > firstWeekAvg * 1.2) return "INCREASING";
        if (lastWeekAvg < firstWeekAvg * 0.8) return "DECREASING";
        return "STABLE";
    }

    private String cleanAiResponse(String aiResponse) {
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
        return cleaned.trim();
    }

    @Transactional
    public void analyzeAllVms() {
        List<Vm> vms = vmRepository.findAll();
        BatchDiskRequestDTO request = new BatchDiskRequestDTO();
        List<BatchDiskRequestDTO.VmDiskData> vmDataList = new ArrayList<>();

        for (Vm vm : vms) {
            if (vm.getDiskFreeMB() == null || vm.getDiskFreePercent() == null) {
                log.warn("VM {} has no disk data, skipping", vm.getName());
                continue;
            }

            List<PerformanceMetric> metrics = metricRepository.findByVmIdAndSavedAtBetween(
                    vm.getId(),
                    LocalDateTime.now().minusDays(30),
                    LocalDateTime.now()
            );

            List<Double> dailyWritesMB = getDailyWritesMB(metrics);
            if (dailyWritesMB.isEmpty()) {
                log.warn("VM {} has no write data, skipping", vm.getName());
                continue;
            }

            double avgDailyWriteMB = calculateAverage(dailyWritesMB);
            double peakDailyWriteMB = calculatePeak(dailyWritesMB);

            BatchDiskRequestDTO.VmDiskData data = new BatchDiskRequestDTO.VmDiskData();
            data.setVmId(vm.getId());
            data.setVmName(vm.getName());
            data.setTotalGB(calculateTotalGB(vm.getDiskFreeMB(), vm.getDiskFreePercent()));
            data.setFreeGB(calculateFreeGB(vm.getDiskFreeMB()));
            data.setFreePercent(vm.getDiskFreePercent());
            data.setAvgDailyWriteMB(avgDailyWriteMB);
            data.setPeakDailyWriteMB(peakDailyWriteMB);
            data.setWriteTrend(calculateTrend(dailyWritesMB));
            data.setVmType(vm.getVmType() != null ? vm.getVmType() : "Unknown");
            vmDataList.add(data);
        }

        if (vmDataList.isEmpty()) {
            log.warn("No VMs with valid disk data found");
            return;
        }

        request.setVms(vmDataList);

        try {
            String prompt = promptBuilder.buildPrompt(request);
            String aiResponse = openRouterClient.sendMessage(prompt);

            String cleanedResponse = cleanAiResponse(aiResponse);

            DiskAnalysisResponseDTO response = objectMapper.readValue(cleanedResponse, DiskAnalysisResponseDTO.class);

            for (DiskAnalysisResponseDTO.VmAnalysis analysis : response.getAnalyses()) {
                analysisRepository.deleteByVmId(analysis.getVmId());
                saveAnalysisToDatabase(analysis);
            }

        } catch (Exception e) {
            log.error("AI analysis failed: {}", e.getMessage());
        }
    }

    private void saveAnalysisToDatabase(DiskAnalysisResponseDTO.VmAnalysis analysis) {
        AIDiskAnalysis entity = AIDiskAnalysis.builder()
                .vmId(analysis.getVmId())
                .vmName(analysis.getVmName())
                .daysUntilFull(analysis.getPrediction().getDaysUntilFull())
                .riskLevel(analysis.getPrediction().getRiskLevel())
                .predictionRecommendation(analysis.getPrediction().getRecommendation())
                .anomalyDetected(analysis.getAnomaly().isDetected())
                .anomalyDetails(analysis.getAnomaly().getDetails())
                .anomalyPossibleCauses(analysis.getAnomaly().getPossibleCauses())
                .optimizationSuggestion(analysis.getOptimization().getSuggestion())
                .optimizationAction(analysis.getOptimization().getAction())
                .createdAt(LocalDateTime.now())
                .build();

        analysisRepository.save(entity);
        log.info("Saved analysis for VM: {}", analysis.getVmName());
    }

    public AIDiskAnalysis getLatestAnalysis(Long vmId) {
        return analysisRepository.findTopByVmIdOrderByCreatedAtDesc(vmId).orElse(null);
    }
}