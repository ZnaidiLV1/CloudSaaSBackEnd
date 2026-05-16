package org.example.ai.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.example.ai.dto.request.MonthlyReportRequestDTOs.*;
import org.example.ai.dto.response.MonthlyReportResponseDTOs.MonthlyReportResponseDTO;
import org.example.ai.entity.AIAlertAnalysis;
import org.example.ai.entity.AIMonthlyReport;
import org.example.ai.entity.AIVmCostAnalysis;
import org.example.ai.prompt.MonthlyReportPromptBuilder;
import org.example.ai.repository.AIAlertAnalysisRepository;
import org.example.ai.repository.AIMonthlyReportRepository;
import org.example.ai.repository.AIVmCostAnalysisRepository;
import org.example.azure.entity.*;
import org.example.azure.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class AIMonthlyReportService {
    private final VmRepository vmRepository;
    private final PerformanceMetricRepository performanceMetricRepository;
    private final AzureAlertRepository alertRepository;
    private final MonthlyCostRepository monthlyCostRepository;
    private final MonthlyVmCostRepository monthlyVmCostRepository;
    private final AIMonthlyReportRepository reportRepository;
    private final BackupJobHistoryRepository backupJobHistoryRepository;
    private final ProtectedItemRepository protectedItemRepository;
    private final AIAlertAnalysisRepository aiAlertAnalysisRepository;
    private final AIVmCostAnalysisRepository aiVmCostAnalysisRepository;
    private final OpenRouterClient openRouterClient;
    private final MonthlyReportPromptBuilder promptBuilder;
    private final ObjectMapper objectMapper;

    private static final double TOTAL_RAM_GB = 8.0;

    private String cleanAiResponse(String aiResponse) {
        if (aiResponse == null || aiResponse.isEmpty()) {
            return "{}";
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
            log.warn("AI returned non-JSON response: {}", cleaned.substring(0, Math.min(200, cleaned.length())));
            return "{}";
        }
        return cleaned;
    }

    private Double calculateUsedRamPercent(Double ramMinGb) {
        if (ramMinGb == null) return null;
        double usedRamGb = TOTAL_RAM_GB - ramMinGb;
        return (usedRamGb / TOTAL_RAM_GB) * 100;
    }

    private MonthlyReportRequestDTO.FinancialData getFinancialData(int year, int month) {
        List<MonthlyCost> currentMonthCosts = monthlyCostRepository.findByMonthAndYear(month, year);
        double currentTotal = currentMonthCosts.stream().mapToDouble(c -> c.getCost().doubleValue()).sum();

        LocalDate prevDate = LocalDate.of(year, month, 1).minusMonths(1);
        int prevYear = prevDate.getYear();
        int prevMonth = prevDate.getMonthValue();
        List<MonthlyCost> prevMonthCosts = monthlyCostRepository.findByMonthAndYear(prevMonth, prevYear);
        double prevTotal = prevMonthCosts.stream().mapToDouble(c -> c.getCost().doubleValue()).sum();

        MonthlyReportRequestDTO.FinancialData data = new MonthlyReportRequestDTO.FinancialData();
        data.setLastMonthTotal(Math.round(currentTotal * 100.0) / 100.0);
        data.setPreviousMonthTotal(Math.round(prevTotal * 100.0) / 100.0);
        return data;
    }

    private MonthlyReportRequestDTO.InventoryData getInventoryData() {
        List<Vm> allVms = vmRepository.findAll();
        MonthlyReportRequestDTO.InventoryData data = new MonthlyReportRequestDTO.InventoryData();
        data.setTotalVMs(allVms.size());

        Map<String, Integer> billingMap = new HashMap<>();
        for (Vm vm : allVms) {
            if (vm.getBillingType() != null) {
                billingMap.merge(vm.getBillingType().toString(), 1, Integer::sum);
            }
        }

        List<MonthlyReportRequestDTO.BillingTypeCount> billingTypes = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : billingMap.entrySet()) {
            MonthlyReportRequestDTO.BillingTypeCount btc = new MonthlyReportRequestDTO.BillingTypeCount();
            btc.setType(entry.getKey());
            btc.setCount(entry.getValue());
            billingTypes.add(btc);
        }
        data.setBillingTypes(billingTypes);
        return data;
    }

    private MonthlyReportRequestDTO.AlertsData getAlertsData(int year, int month) {
        LocalDateTime startDate = LocalDate.of(year, month, 1).atStartOfDay();
        LocalDateTime endDate = startDate.plusMonths(1).minusSeconds(1);

        List<AzureAlert> alerts = alertRepository.findByOccurredAtBetween(startDate, endDate);

        MonthlyReportRequestDTO.AlertsData data = new MonthlyReportRequestDTO.AlertsData();
        data.setTotalAlerts(alerts.size());

        Map<String, Integer> byType = new HashMap<>();
        Map<Long, Map<String, Integer>> byVmMap = new HashMap<>();
        Map<Long, String> vmNames = new HashMap<>();

        for (AzureAlert alert : alerts) {
            byType.merge(alert.getAlertName(), 1, Integer::sum);
            if (alert.getVm() != null) {
                Long vmId = alert.getVm().getId();
                vmNames.put(vmId, alert.getVm().getName());
                byVmMap.computeIfAbsent(vmId, k -> new HashMap<>()).merge(alert.getAlertName(), 1, Integer::sum);
            }
        }

        List<MonthlyReportRequestDTO.AlertTypeCount> alertsByType = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : byType.entrySet()) {
            MonthlyReportRequestDTO.AlertTypeCount atc = new MonthlyReportRequestDTO.AlertTypeCount();
            atc.setAlertName(entry.getKey());
            atc.setCount(entry.getValue());
            alertsByType.add(atc);
        }
        data.setAlertsByType(alertsByType);

        List<MonthlyReportRequestDTO.AlertByVm> alertsByVM = new ArrayList<>();
        for (Map.Entry<Long, Map<String, Integer>> entry : byVmMap.entrySet()) {
            MonthlyReportRequestDTO.AlertByVm avm = new MonthlyReportRequestDTO.AlertByVm();
            avm.setVmId(entry.getKey());
            avm.setVmName(vmNames.get(entry.getKey()));
            avm.setTotalAlerts(entry.getValue().values().stream().mapToInt(Integer::intValue).sum());
            List<MonthlyReportRequestDTO.AlertTypeCount> vmAlertTypes = new ArrayList<>();
            for (Map.Entry<String, Integer> innerEntry : entry.getValue().entrySet()) {
                MonthlyReportRequestDTO.AlertTypeCount atc = new MonthlyReportRequestDTO.AlertTypeCount();
                atc.setAlertName(innerEntry.getKey());
                atc.setCount(innerEntry.getValue());
                vmAlertTypes.add(atc);
            }
            avm.setAlertsByType(vmAlertTypes);
            alertsByVM.add(avm);
        }
        data.setAlertsByVM(alertsByVM);
        return data;
    }

    private List<MonthlyReportRequestDTO.AiAlertAnalysisData> getAiAlertAnalyses() {
        List<Vm> allVms = vmRepository.findAll();
        List<MonthlyReportRequestDTO.AiAlertAnalysisData> result = new ArrayList<>();
        for (Vm vm : allVms) {
            Optional<AIAlertAnalysis> analysisOpt = aiAlertAnalysisRepository.findTopByVmIdOrderByCreatedAtDesc(vm.getId());
            if (analysisOpt.isPresent()) {
                AIAlertAnalysis analysis = analysisOpt.get();
                MonthlyReportRequestDTO.AiAlertAnalysisData data = new MonthlyReportRequestDTO.AiAlertAnalysisData();
                data.setVmId(vm.getId());
                data.setVmName(vm.getName());
                data.setHasPattern(analysis.getAlertHasPattern());
                data.setPatternDescription(analysis.getAlertPatternDescription());
                data.setSuggestionAction(analysis.getSuggestionAction());
                result.add(data);
            } else {
                MonthlyReportRequestDTO.AiAlertAnalysisData data = new MonthlyReportRequestDTO.AiAlertAnalysisData();
                data.setVmId(vm.getId());
                data.setVmName(vm.getName());
                data.setHasPattern(false);
                data.setPatternDescription(null);
                data.setSuggestionAction(null);
                result.add(data);
            }
        }
        return result;
    }

    private List<MonthlyReportRequestDTO.PerformanceData> getPerformanceData(int year, int month) {
        List<Vm> allVms = vmRepository.findAll();
        List<MonthlyReportRequestDTO.PerformanceData> result = new ArrayList<>();

        LocalDateTime startDate = LocalDate.of(year, month, 1).atStartOfDay();
        LocalDateTime endDate = startDate.plusMonths(1).minusSeconds(1);

        for (Vm vm : allVms) {
            List<PerformanceMetric> metrics = performanceMetricRepository.findByVmIdAndSavedAtBetween(vm.getId(), startDate, endDate);
            if (metrics.isEmpty()) {
                MonthlyReportRequestDTO.PerformanceData data = new MonthlyReportRequestDTO.PerformanceData();
                data.setVmId(vm.getId());
                data.setVmName(vm.getName());
                data.setAvgCpu(0.0);
                data.setMaxCpu(0.0);
                data.setMaxCpuDate(null);
                data.setAvgRam(0.0);
                data.setMaxUsedRam(0.0);
                data.setMaxUsedRamDate(null);
                result.add(data);
                continue;
            }

            double avgCpu = metrics.stream().mapToDouble(m -> m.getCpuAvg() != null ? m.getCpuAvg() : 0).average().orElse(0);
            PerformanceMetric maxCpuMetric = metrics.stream().max(Comparator.comparing(m -> m.getCpuMax() != null ? m.getCpuMax() : 0)).orElse(null);
            double maxCpu = maxCpuMetric != null && maxCpuMetric.getCpuMax() != null ? maxCpuMetric.getCpuMax() : 0;
            String maxCpuDate = maxCpuMetric != null && maxCpuMetric.getSavedAt() != null ? maxCpuMetric.getSavedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : null;

            double avgRam = metrics.stream().mapToDouble(m -> {
                if (m.getRamMin() != null) {
                    return calculateUsedRamPercent(m.getRamMin());
                }
                return 0;
            }).average().orElse(0);

            PerformanceMetric minRamMetric = metrics.stream().min(Comparator.comparing(m -> m.getRamMin() != null ? m.getRamMin() : Double.MAX_VALUE)).orElse(null);
            double maxUsedRam = 0;
            String maxUsedRamDate = null;
            if (minRamMetric != null && minRamMetric.getRamMin() != null) {
                maxUsedRam = calculateUsedRamPercent(minRamMetric.getRamMin());
                maxUsedRamDate = minRamMetric.getSavedAt() != null ? minRamMetric.getSavedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")) : null;
            }

            MonthlyReportRequestDTO.PerformanceData data = new MonthlyReportRequestDTO.PerformanceData();
            data.setVmId(vm.getId());
            data.setVmName(vm.getName());
            data.setAvgCpu(Math.round(avgCpu * 10.0) / 10.0);
            data.setMaxCpu(Math.round(maxCpu * 10.0) / 10.0);
            data.setMaxCpuDate(maxCpuDate);
            data.setAvgRam(Math.round(avgRam * 10.0) / 10.0);
            data.setMaxUsedRam(Math.round(maxUsedRam * 10.0) / 10.0);
            data.setMaxUsedRamDate(maxUsedRamDate);
            result.add(data);
        }
        return result;
    }

    private List<MonthlyReportRequestDTO.BackupData> getBackupData(int year, int month) {
        LocalDateTime startDate = LocalDate.of(year, month, 1).atStartOfDay();
        LocalDateTime endDate = startDate.plusMonths(1).minusSeconds(1);

        List<MonthlyReportRequestDTO.BackupData> result = new ArrayList<>();

        // Get all VMs first
        List<Vm> allVms = vmRepository.findAll();

        // Create a map of VM ID to backup stats
        Map<Long, MonthlyReportRequestDTO.BackupData> backupMap = new HashMap<>();

        // Initialize map with all VMs (default null values)
        for (Vm vm : allVms) {
            MonthlyReportRequestDTO.BackupData data = new MonthlyReportRequestDTO.BackupData();
            data.setVmId(vm.getId());
            data.setVmName(vm.getName());
            data.setSuccessRate(null);
            data.setTotalBackups(null);
            data.setFailedBackups(null);
            backupMap.put(vm.getId(), data);
        }

        // Get backup stats directly from BackupJobHistory
        List<Object[]> stats = backupJobHistoryRepository.getBackupStatsGroupedByVm(startDate, endDate);

        if (stats != null) {
            for (Object[] row : stats) {
                Long vmId = ((Number) row[0]).longValue();
                String vmName = (String) row[1];
                Long totalBackups = ((Number) row[2]).longValue();
                Long completedBackups = ((Number) row[3]).longValue();

                MonthlyReportRequestDTO.BackupData data = backupMap.get(vmId);
                if (data != null) {
                    int successRate = totalBackups > 0 ? (int) ((completedBackups * 100) / totalBackups) : 0;
                    data.setSuccessRate(successRate);
                    data.setTotalBackups(totalBackups.intValue());
                    data.setFailedBackups((totalBackups.intValue() - completedBackups.intValue()));
                }
            }
        }

        return new ArrayList<>(backupMap.values());
    }

    private List<MonthlyReportRequestDTO.VmCostData> getVmCostsData(int year, int month) {
        List<Vm> allVms = vmRepository.findAll();
        List<MonthlyReportRequestDTO.VmCostData> result = new ArrayList<>();

        for (Vm vm : allVms) {
            Optional<MonthlyVmCost> costOpt = monthlyVmCostRepository.findByVmIdAndYearAndMonth(vm.getId(), year, month);
            MonthlyReportRequestDTO.VmCostData data = new MonthlyReportRequestDTO.VmCostData();
            data.setVmId(vm.getId());
            data.setVmName(vm.getName());
            if (costOpt.isPresent()) {
                MonthlyVmCost cost = costOpt.get();
                data.setDirectCost(Math.round(cost.getDirectCost().doubleValue() * 100.0) / 100.0);
                data.setReservationCost(Math.round(cost.getReservationCost().doubleValue() * 100.0) / 100.0);
                data.setSharedCost(Math.round(cost.getSharedCost().doubleValue() * 100.0) / 100.0);
                data.setTotalCost(Math.round(cost.getTotalCost().doubleValue() * 100.0) / 100.0);
            } else {
                data.setDirectCost(0.0);
                data.setReservationCost(0.0);
                data.setSharedCost(0.0);
                data.setTotalCost(0.0);
            }
            result.add(data);
        }
        return result;
    }

    private List<MonthlyReportRequestDTO.AiVmCostAnalysisData> getAiVmCostAnalyses() {
        List<Vm> allVms = vmRepository.findAll();
        List<MonthlyReportRequestDTO.AiVmCostAnalysisData> result = new ArrayList<>();
        for (Vm vm : allVms) {
            Optional<AIVmCostAnalysis> analysisOpt = aiVmCostAnalysisRepository.findTopByVmIdOrderByCreatedAtDesc(vm.getId());
            if (analysisOpt.isPresent()) {
                AIVmCostAnalysis analysis = analysisOpt.get();
                MonthlyReportRequestDTO.AiVmCostAnalysisData data = new MonthlyReportRequestDTO.AiVmCostAnalysisData();
                data.setVmId(vm.getId());
                data.setVmName(vm.getName());
                data.setTrend(analysis.getTrend());
                data.setMonthOverMonthChange(analysis.getMonthOverMonthChange());
                data.setRecommendationAction(analysis.getRecommendationAction());
                result.add(data);
            } else {
                MonthlyReportRequestDTO.AiVmCostAnalysisData data = new MonthlyReportRequestDTO.AiVmCostAnalysisData();
                data.setVmId(vm.getId());
                data.setVmName(vm.getName());
                data.setTrend(null);
                data.setMonthOverMonthChange(null);
                data.setRecommendationAction(null);
                result.add(data);
            }
        }
        return result;
    }

    private String convertToJsonString(Object obj) {
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (Exception e) {
            log.error("Failed to convert object to JSON: {}", e.getMessage());
            return null;
        }
    }

    @Transactional
    public void generateMonthlyReport(Integer reportYear, Integer reportMonth) {
        log.info("=== STARTING MONTHLY REPORT GENERATION FOR {}-{} ===", reportYear, reportMonth);

        MonthlyReportRequestDTO request = new MonthlyReportRequestDTO();
        request.setReportMonth(reportMonth);
        request.setReportYear(reportYear);
        request.setFinancial(getFinancialData(reportYear, reportMonth));
        request.setInventory(getInventoryData());
        request.setAlerts(getAlertsData(reportYear, reportMonth));
        request.setAiAlertAnalyses(getAiAlertAnalyses());
        request.setPerformance(getPerformanceData(reportYear, reportMonth));
        request.setBackup(getBackupData(reportYear, reportMonth));
        request.setVmCosts(getVmCostsData(reportYear, reportMonth));
        request.setAiVmCostAnalyses(getAiVmCostAnalyses());

        try {
            String requestJson = objectMapper.writeValueAsString(request);
            log.info("=== REQUEST JSON SENT TO AI ===");
            log.info(requestJson);
            log.info("=== END REQUEST JSON ===");

            String prompt = promptBuilder.buildPrompt(request);
            String aiResponse = openRouterClient.sendMessage(prompt);
            String cleanedResponse = cleanAiResponse(aiResponse);

            log.info("=== AI RESPONSE RECEIVED ===");
            log.info(cleanedResponse);
            log.info("=== END AI RESPONSE ===");

            MonthlyReportResponseDTO response = objectMapper.readValue(cleanedResponse, MonthlyReportResponseDTO.class);

            Optional<AIMonthlyReport> existingReport = reportRepository.findAll().stream()
                    .filter(r -> r.getReportYear().equals(reportYear) && r.getReportMonth().equals(reportMonth))
                    .findFirst();
            existingReport.ifPresent(report -> reportRepository.delete(report));

            saveReportToDatabase(response);

            log.info("Monthly report for {}-{} generated and saved successfully", reportYear, reportMonth);
        } catch (Exception e) {
            log.error("Monthly report generation failed: {}", e.getMessage(), e);
        }

        log.info("=== FINISHED MONTHLY REPORT GENERATION ===");
    }

    private void saveReportToDatabase(MonthlyReportResponseDTO response) {
        try {
            AIMonthlyReport entity = AIMonthlyReport.builder()
                    .reportMonth(response.getReportMonth())
                    .reportYear(response.getReportYear())
                    .lastMonthInvoiceValue(response.getLastMonthInvoiceValue())
                    .invoicePercentChange(response.getInvoicePercentChange())
                    .totalVMs(response.getTotalVMs())
                    .billingTypes(convertToJsonString(response.getBillingTypes()))
                    .totalAlerts(response.getTotalAlerts())
                    .alertsByType(convertToJsonString(response.getAlertsByType()))
                    .alertsByVM(convertToJsonString(response.getAlertsByVM()))
                    .aiAlertAnalysis(response.getAiAlertAnalysis())
                    .aiAlertRecommendation(response.getAiAlertRecommendation())
                    .performanceData(convertToJsonString(response.getPerformanceData()))
                    .aiPerformanceAnalysis(response.getAiPerformanceAnalysis())
                    .aiPerformanceRecommendation(response.getAiPerformanceRecommendation())
                    .backupData(convertToJsonString(response.getBackupData()))
                    .aiBackupAnalysis(response.getAiBackupAnalysis())
                    .aiBackupRecommendation(response.getAiBackupRecommendation())
                    .financialData(convertToJsonString(response.getFinancialData()))
                    .aiCostAnalysis(response.getAiCostAnalysis())
                    .aiCostRecommendation(response.getAiCostRecommendation())
                    .aiInfrastructureSummary(response.getAiInfrastructureSummary())
                    .createdAt(LocalDateTime.now())
                    .build();
            reportRepository.save(entity);
            log.info("Saved monthly report for {}-{}", response.getReportYear(), response.getReportMonth());
        } catch (Exception e) {
            log.error("Failed to save monthly report: {}", e.getMessage(), e);
        }
    }

    public AIMonthlyReport getMonthlyReportByMonthAndYear(Integer reportYear, Integer reportMonth) {
        List<AIMonthlyReport> reports = reportRepository.findAll();
        return reports.stream()
                .filter(r -> r.getReportYear().equals(reportYear) && r.getReportMonth().equals(reportMonth))
                .findFirst()
                .orElse(null);
    }
}