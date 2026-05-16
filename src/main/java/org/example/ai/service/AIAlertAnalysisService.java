package org.example.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.example.ai.dto.request.AlertRequestDTOs.BatchAlertRequestDTO;
import org.example.ai.dto.response.AlertResponseDTOs.AlertAnalysisResponseDTO;
import org.example.ai.entity.AIAlertAnalysis;
import org.example.ai.prompt.AlertAnalysisPromptBuilder;
import org.example.ai.repository.AIAlertAnalysisRepository;
import org.example.azure.entity.AzureAlert;
import org.example.azure.entity.Vm;
import org.example.azure.repository.AzureAlertRepository;
import org.example.azure.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIAlertAnalysisService {
    private final VmRepository vmRepository;
    private final AzureAlertRepository alertRepository;
    private final OpenRouterClient openRouterClient;
    private final AIAlertAnalysisRepository analysisRepository;
    private final AlertAnalysisPromptBuilder promptBuilder;
    private final ObjectMapper objectMapper;

    private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private String cleanAiResponse(String aiResponse) {
        if (aiResponse == null || aiResponse.isEmpty()) {
            return "{\"analyses\":[]}";
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
        return cleaned.trim();
    }

    private Long calculateDurationSeconds(LocalDateTime occurredAt, LocalDateTime resolvedAt) {
        if (occurredAt == null || resolvedAt == null) {
            return null;
        }
        return java.time.Duration.between(occurredAt, resolvedAt).getSeconds();
    }

    public List<AIAlertAnalysis> getAllAlertAnalyses() {
        log.info("Fetching all alert analyses from database");
        return analysisRepository.findAll();
    }

    public AIAlertAnalysis getLatestAlertAnalysis(Long vmId) {
        log.info("Fetching alert analysis for VM {} from database", vmId);
        return analysisRepository.findTopByVmIdOrderByCreatedAtDesc(vmId).orElse(null);
    }

    @Transactional
    public void analyzeAlertsForSingleVm(Long vmId) {
        log.info("=== STARTING ALERT ANALYSIS FOR SINGLE VM: {} ===", vmId);

        Optional<Vm> vmOptional = vmRepository.findById(vmId);
        if (vmOptional.isEmpty()) {
            log.error("VM with ID {} not found", vmId);
            return;
        }

        Vm vm = vmOptional.get();
        log.info("VM Name: {}", vm.getName());

        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = endDate.minusDays(30);

        List<AzureAlert> alerts = alertRepository.findByVmIdAndOccurredAtBetween(vm.getId(), startDate, endDate);

        if (alerts.isEmpty()) {
            log.warn("VM {} has no alerts in last 30 days", vm.getName());
            return;
        }

        log.info("Found {} alerts for VM {} in last 30 days", alerts.size(), vm.getName());

        List<BatchAlertRequestDTO.AlertDetail> alertDetails = new ArrayList<>();
        for (AzureAlert alert : alerts) {
            BatchAlertRequestDTO.AlertDetail detail = new BatchAlertRequestDTO.AlertDetail();
            detail.setAlertName(alert.getAlertName());
            detail.setDescription(alert.getDescription());
            detail.setOccurredAt(alert.getOccurredAt() != null ? alert.getOccurredAt().format(DATETIME_FORMATTER) : null);
            detail.setMetricValue(alert.getMetricValue());
            detail.setResolvedAt(alert.getResolvedAt() != null ? alert.getResolvedAt().format(DATETIME_FORMATTER) : null);
            detail.setDurationSeconds(calculateDurationSeconds(alert.getOccurredAt(), alert.getResolvedAt()));
            detail.setMonitorCondition(alert.getMonitorCondition());
            alertDetails.add(detail);
        }

        BatchAlertRequestDTO request = new BatchAlertRequestDTO();
        List<BatchAlertRequestDTO.VmAlertData> vmAlertDataList = new ArrayList<>();

        BatchAlertRequestDTO.VmAlertData vmData = new BatchAlertRequestDTO.VmAlertData();
        vmData.setVmId(vm.getId());
        vmData.setVmName(vm.getName());
        vmData.setAlerts(alertDetails);
        vmAlertDataList.add(vmData);
        request.setVms(vmAlertDataList);

        try {
            String prompt = promptBuilder.buildPrompt(request);
            log.info("Prompt length for VM {}: {} characters", vm.getName(), prompt.length());

            String aiResponse = openRouterClient.sendMessage(prompt);
            log.info("AI response received, length: {}", aiResponse != null ? aiResponse.length() : 0);

            if (aiResponse == null || aiResponse.isEmpty()) {
                log.error("No response from AI for VM {}", vm.getName());
                return;
            }

            String cleanedResponse = cleanAiResponse(aiResponse);
            AlertAnalysisResponseDTO response = objectMapper.readValue(cleanedResponse, AlertAnalysisResponseDTO.class);

            if (response.getAnalyses() != null && !response.getAnalyses().isEmpty()) {
                analysisRepository.deleteByVmId(vm.getId());
                saveAnalysisToDatabase(response.getAnalyses().get(0));
                log.info("Successfully saved alert analysis for VM: {}", vm.getName());
            } else {
                log.warn("No analysis returned for VM: {}", vm.getName());
            }

        } catch (Exception e) {
            log.error("Failed to analyze alerts for VM {}: {}", vm.getName(), e.getMessage(), e);
        }

        log.info("=== FINISHED ALERT ANALYSIS FOR VM: {} ===", vmId);
    }

    @Transactional
    public void analyzeAllVmsAlerts() {
        List<Vm> allVms = vmRepository.findAll();
        log.info("=== STARTING ALERT ANALYSIS FOR {} VMs ===", allVms.size());

        int successCount = 0;
        int failCount = 0;
        int skipCount = 0;

        for (int i = 0; i < allVms.size(); i++) {
            Vm vm = allVms.get(i);
            log.info("Processing VM {}/{}: {} (ID: {})", i + 1, allVms.size(), vm.getName(), vm.getId());

            try {
                LocalDateTime endDate = LocalDateTime.now();
                LocalDateTime startDate = endDate.minusDays(30);
                List<AzureAlert> alerts = alertRepository.findByVmIdAndOccurredAtBetween(vm.getId(), startDate, endDate);

                if (alerts.isEmpty()) {
                    log.warn("VM {} has no alerts in last 30 days, skipping", vm.getName());
                    skipCount++;
                    continue;
                }

                List<BatchAlertRequestDTO.AlertDetail> alertDetails = new ArrayList<>();
                for (AzureAlert alert : alerts) {
                    BatchAlertRequestDTO.AlertDetail detail = new BatchAlertRequestDTO.AlertDetail();
                    detail.setAlertName(alert.getAlertName());
                    detail.setDescription(alert.getDescription());
                    detail.setOccurredAt(alert.getOccurredAt() != null ? alert.getOccurredAt().format(DATETIME_FORMATTER) : null);
                    detail.setMetricValue(alert.getMetricValue());
                    detail.setResolvedAt(alert.getResolvedAt() != null ? alert.getResolvedAt().format(DATETIME_FORMATTER) : null);
                    detail.setDurationSeconds(calculateDurationSeconds(alert.getOccurredAt(), alert.getResolvedAt()));
                    detail.setMonitorCondition(alert.getMonitorCondition());
                    alertDetails.add(detail);
                }

                BatchAlertRequestDTO request = new BatchAlertRequestDTO();
                List<BatchAlertRequestDTO.VmAlertData> vmAlertDataList = new ArrayList<>();

                BatchAlertRequestDTO.VmAlertData vmData = new BatchAlertRequestDTO.VmAlertData();
                vmData.setVmId(vm.getId());
                vmData.setVmName(vm.getName());
                vmData.setAlerts(alertDetails);
                vmAlertDataList.add(vmData);
                request.setVms(vmAlertDataList);

                String prompt = promptBuilder.buildPrompt(request);
                String aiResponse = openRouterClient.sendMessage(prompt);

                if (aiResponse == null || aiResponse.isEmpty()) {
                    log.error("No response from AI for VM {}", vm.getName());
                    failCount++;
                    continue;
                }

                String cleanedResponse = cleanAiResponse(aiResponse);
                AlertAnalysisResponseDTO response = objectMapper.readValue(cleanedResponse, AlertAnalysisResponseDTO.class);

                if (response.getAnalyses() != null && !response.getAnalyses().isEmpty()) {
                    analysisRepository.deleteByVmId(vm.getId());
                    saveAnalysisToDatabase(response.getAnalyses().get(0));
                    successCount++;
                    log.info("Saved alert analysis for VM: {}", vm.getName());
                } else {
                    failCount++;
                }

                if (i < allVms.size() - 1) {
                    Thread.sleep(2000);
                }

            } catch (Exception e) {
                log.error("Failed to analyze VM {}: {}", vm.getName(), e.getMessage());
                failCount++;
            }
        }

        log.info("=== ALERT ANALYSIS COMPLETED ===");
        log.info("Success: {}, Failed: {}, Skipped: {}", successCount, failCount, skipCount);
    }

    private void saveAnalysisToDatabase(AlertAnalysisResponseDTO.VmAlertAnalysis analysis) {
        AIAlertAnalysis entity = AIAlertAnalysis.builder()
                .vmId(analysis.getVmId())
                .vmName(analysis.getVmName())
                .alertHasPattern(analysis.getAlertPattern() != null ? analysis.getAlertPattern().getHasPattern() : false)
                .alertPatternDescription(analysis.getAlertPattern() != null ? analysis.getAlertPattern().getDescription() : null)
                .frequencyPerDay(analysis.getAlertPattern() != null ? analysis.getAlertPattern().getFrequencyPerDay() : null)
                .averageDurationMinutes(analysis.getAlertPattern() != null ? analysis.getAlertPattern().getAverageDurationMinutes() : null)
                .peakHour(analysis.getAlertPattern() != null ? analysis.getAlertPattern().getPeakHour() : null)
                .peakDay(analysis.getAlertPattern() != null ? analysis.getAlertPattern().getPeakDay() : null)
                .predictionNextAlert(analysis.getPrediction() != null ? analysis.getPrediction().getNextExpectedAlert() : null)
                .predictionTrend(analysis.getPrediction() != null ? analysis.getPrediction().getTrend() : null)
                .anomalyDetected(analysis.getAnomaly() != null ? analysis.getAnomaly().getDetected() : false)
                .anomalyDetails(analysis.getAnomaly() != null ? analysis.getAnomaly().getDetails() : null)
                .suggestionAction(analysis.getSuggestion() != null ? analysis.getSuggestion().getAction() : "NONE")
                .suggestionText(analysis.getSuggestion() != null ? analysis.getSuggestion().getSuggestion() : null)
                .createdAt(LocalDateTime.now())
                .build();

        analysisRepository.save(entity);
    }
}