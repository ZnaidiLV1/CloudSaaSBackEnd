package org.example.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.example.ai.dto.request.RamCpuAIRequestsDTOs.BatchCpuRamRequestDTO;
import org.example.ai.dto.response.RamCpuAIResponsesDTOs.CpuRamAnalysisResponseDTO;
import org.example.ai.entity.AICpuRamAnalysis;
import org.example.ai.prompt.CpuRamAnalysisPromptBuilder;
import org.example.ai.repository.AICpuRamAnalysisRepository;
import org.example.azure.entity.PerformanceMetric;
import org.example.azure.entity.Vm;
import org.example.azure.repository.PerformanceMetricRepository;
import org.example.azure.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class AICpuRamAnalysisService {
    private final VmRepository vmRepository;
    private final PerformanceMetricRepository metricRepository;
    private final OpenRouterClient openRouterClient;
    private final AICpuRamAnalysisRepository analysisRepository;
    private final CpuRamAnalysisPromptBuilder promptBuilder;
    private final ObjectMapper objectMapper;

    private static final double TOTAL_RAM_GB = 8.0;

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

    private List<PerformanceMetric> getMetricsForDateRange(Long vmId, LocalDateTime start, LocalDateTime end) {
        return metricRepository.findByVmIdAndSavedAtBetween(vmId, start, end);
    }

    private Map<LocalDate, Double> getDailyMaxCpu(List<PerformanceMetric> metrics) {
        Map<LocalDate, Double> dailyMax = new HashMap<>();
        for (PerformanceMetric metric : metrics) {
            if (metric.getCpuMax() != null) {
                LocalDate date = metric.getSavedAt().toLocalDate();
                if (!dailyMax.containsKey(date) || metric.getCpuMax() > dailyMax.get(date)) {
                    dailyMax.put(date, metric.getCpuMax());
                }
            }
        }
        return dailyMax;
    }

    private Map<LocalDate, LocalDateTime> getDailyCpuPeakTime(List<PerformanceMetric> metrics) {
        Map<LocalDate, LocalDateTime> dailyPeakTime = new HashMap<>();
        Map<LocalDate, Double> dailyMax = new HashMap<>();

        for (PerformanceMetric metric : metrics) {
            if (metric.getCpuMax() != null) {
                LocalDate date = metric.getSavedAt().toLocalDate();
                if (!dailyMax.containsKey(date) || metric.getCpuMax() > dailyMax.get(date)) {
                    dailyMax.put(date, metric.getCpuMax());
                    dailyPeakTime.put(date, metric.getSavedAt());
                }
            }
        }
        return dailyPeakTime;
    }

    private Map<LocalDate, Double> getDailyMaxUsedRamPercent(List<PerformanceMetric> metrics) {
        Map<LocalDate, Double> dailyMaxRamPercent = new HashMap<>();

        for (PerformanceMetric metric : metrics) {
            if (metric.getRamMin() != null) {
                LocalDate date = metric.getSavedAt().toLocalDate();
                double usedRamPercent = ((TOTAL_RAM_GB - metric.getRamMin()) / TOTAL_RAM_GB) * 100;
                if (!dailyMaxRamPercent.containsKey(date) || usedRamPercent > dailyMaxRamPercent.get(date)) {
                    dailyMaxRamPercent.put(date, usedRamPercent);
                }
            }
        }
        return dailyMaxRamPercent;
    }

    private Map<LocalDate, LocalDateTime> getDailyRamPeakTime(List<PerformanceMetric> metrics) {
        Map<LocalDate, LocalDateTime> dailyPeakTime = new HashMap<>();
        Map<LocalDate, Double> dailyMaxPercent = new HashMap<>();

        for (PerformanceMetric metric : metrics) {
            if (metric.getRamMin() != null) {
                LocalDate date = metric.getSavedAt().toLocalDate();
                double usedRamPercent = ((TOTAL_RAM_GB - metric.getRamMin()) / TOTAL_RAM_GB) * 100;
                if (!dailyMaxPercent.containsKey(date) || usedRamPercent > dailyMaxPercent.get(date)) {
                    dailyMaxPercent.put(date, usedRamPercent);
                    dailyPeakTime.put(date, metric.getSavedAt());
                }
            }
        }
        return dailyPeakTime;
    }

    private List<BatchCpuRamRequestDTO.DailyCpuRam> buildDailyDataList(Map<LocalDate, Double> dailyMaxCpu,
                                                                       Map<LocalDate, LocalDateTime> dailyCpuTime,
                                                                       Map<LocalDate, Double> dailyMaxRamPercent,
                                                                       Map<LocalDate, LocalDateTime> dailyRamTime) {
        List<BatchCpuRamRequestDTO.DailyCpuRam> dailyList = new ArrayList<>();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");

        Set<LocalDate> allDates = new HashSet<>();
        allDates.addAll(dailyMaxCpu.keySet());
        allDates.addAll(dailyMaxRamPercent.keySet());

        for (LocalDate date : allDates) {
            BatchCpuRamRequestDTO.DailyCpuRam daily = new BatchCpuRamRequestDTO.DailyCpuRam();
            daily.setDate(date.format(dateFormatter));
            daily.setMaxCpuPercent(dailyMaxCpu.getOrDefault(date, 0.0));
            if (dailyCpuTime.containsKey(date)) {
                daily.setCpuPeakTime(dailyCpuTime.get(date).format(timeFormatter));
            } else {
                daily.setCpuPeakTime("00:00:00");
            }
            daily.setMaxUsedRamPercent(dailyMaxRamPercent.getOrDefault(date, 0.0));
            if (dailyRamTime.containsKey(date)) {
                daily.setRamPeakTime(dailyRamTime.get(date).format(timeFormatter));
            } else {
                daily.setRamPeakTime("00:00:00");
            }
            dailyList.add(daily);
        }
        dailyList.sort((a, b) -> a.getDate().compareTo(b.getDate()));
        return dailyList;
    }

    @Transactional
    public void analyzeAllVmsCpuRam() {
        List<Vm> vms = vmRepository.findAll();
        BatchCpuRamRequestDTO request = new BatchCpuRamRequestDTO();
        List<BatchCpuRamRequestDTO.VmCpuRamData> vmDataList = new ArrayList<>();

        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = endDate.minusDays(30);

        for (Vm vm : vms) {
            List<PerformanceMetric> metrics = getMetricsForDateRange(vm.getId(), startDate, endDate);

            if (metrics.isEmpty()) {
                log.warn("VM {} has no metrics in last 30 days, skipping", vm.getName());
                continue;
            }

            Map<LocalDate, Double> dailyMaxCpu = getDailyMaxCpu(metrics);
            Map<LocalDate, LocalDateTime> dailyCpuTime = getDailyCpuPeakTime(metrics);
            Map<LocalDate, Double> dailyMaxRamPercent = getDailyMaxUsedRamPercent(metrics);
            Map<LocalDate, LocalDateTime> dailyRamTime = getDailyRamPeakTime(metrics);

            List<BatchCpuRamRequestDTO.DailyCpuRam> dailyData = buildDailyDataList(dailyMaxCpu, dailyCpuTime, dailyMaxRamPercent, dailyRamTime);

            if (dailyData.isEmpty()) {
                log.warn("VM {} has no daily data, skipping", vm.getName());
                continue;
            }

            BatchCpuRamRequestDTO.VmCpuRamData vmData = new BatchCpuRamRequestDTO.VmCpuRamData();
            vmData.setVmId(vm.getId());
            vmData.setVmName(vm.getName());
            vmData.setDailyData(dailyData);
            vmDataList.add(vmData);
        }

        if (vmDataList.isEmpty()) {
            log.warn("No VMs with valid CPU/RAM data found");
            return;
        }

        request.setVms(vmDataList);

        try {
            String prompt = promptBuilder.buildPrompt(request);
            String aiResponse = openRouterClient.sendMessage(prompt);
            String cleanedResponse = cleanAiResponse(aiResponse);
            CpuRamAnalysisResponseDTO response = objectMapper.readValue(cleanedResponse, CpuRamAnalysisResponseDTO.class);

            for (CpuRamAnalysisResponseDTO.VmCpuRamAnalysis analysis : response.getAnalyses()) {
                analysisRepository.deleteByVmId(analysis.getVmId());
                saveAnalysisToDatabase(analysis);
            }
        } catch (Exception e) {
            log.error("CPU/RAM AI analysis failed: {}", e.getMessage());
        }
    }

    private void saveAnalysisToDatabase(CpuRamAnalysisResponseDTO.VmCpuRamAnalysis analysis) {
        AICpuRamAnalysis entity = AICpuRamAnalysis.builder()
                .vmId(analysis.getVmId())
                .vmName(analysis.getVmName())
                .cpuHasPattern(analysis.getCpuPattern().getHasPattern())
                .cpuPatternDescription(analysis.getCpuPattern().getDescription())
                .cpuPeakDay(analysis.getCpuPattern().getPeakDay())
                .cpuPeakHour(analysis.getCpuPattern().getPeakHour())
                .cpuSeverity(analysis.getCpuPattern().getSeverity())
                .ramHasPattern(analysis.getRamPattern().getHasPattern())
                .ramPatternDescription(analysis.getRamPattern().getDescription())
                .ramSeverity(analysis.getRamPattern().getSeverity())
                .anomalyDetected(analysis.getAnomaly().getDetected())
                .anomalyDetails(analysis.getAnomaly().getDetails())
                .recommendationAction(analysis.getRecommendation().getAction())
                .recommendationSuggestion(analysis.getRecommendation().getSuggestion())
                .createdAt(LocalDateTime.now())
                .build();

        analysisRepository.save(entity);
        log.info("Saved CPU/RAM analysis for VM: {}", analysis.getVmName());
    }

    public AICpuRamAnalysis getLatestCpuRamAnalysis(Long vmId) {
        return analysisRepository.findTopByVmIdOrderByCreatedAtDesc(vmId).orElse(null);
    }
}