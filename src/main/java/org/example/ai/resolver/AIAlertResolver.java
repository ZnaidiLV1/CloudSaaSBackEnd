package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.entity.AIAlertAnalysis;
import org.example.ai.service.AIAlertAnalysisService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import java.util.Collections;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AIAlertResolver {
    private final AIAlertAnalysisService alertAnalysisService;

    @QueryMapping
    public List<AIAlertAnalysis> getAlertAnalysis(@Argument Long vmId) {
        log.info("Fetching alert analysis for VM: {}", vmId);
        if (vmId == null || vmId == 0) {
            log.info("Fetching all alert analyses");
            List<AIAlertAnalysis> analyses = alertAnalysisService.getAllAlertAnalyses();
            return analyses != null ? analyses : Collections.emptyList();
        }
        AIAlertAnalysis analysis = alertAnalysisService.getLatestAlertAnalysis(vmId);
        if (analysis == null) {
            return Collections.emptyList();
        }
        return List.of(analysis);
    }

    @MutationMapping
    public String analyzeAlertsForVm(@Argument Long vmId) {
        log.info("Manual trigger: Analyzing alerts for VM ID: {}", vmId);
        alertAnalysisService.analyzeAlertsForSingleVm(vmId);
        return "Alert analysis completed for VM ID: " + vmId;
    }

    @MutationMapping
    public String analyzeAllVmsAlerts() {
        log.info("Manual trigger: Analyzing all VMs alerts");
        alertAnalysisService.analyzeAllVmsAlerts();
        return "Alert analysis completed for all VMs";
    }
}