package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.entity.AIVmCostAnalysis;
import org.example.ai.service.AIVmCostAnalysisService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AIVmCostResolver {
    private final AIVmCostAnalysisService vmCostAnalysisService;

    @QueryMapping
    public AIVmCostAnalysis getVmCostAnalysis(@Argument Long vmId) {
        log.info("Fetching VM cost analysis for VM: {}", vmId);
        AIVmCostAnalysis analysis = vmCostAnalysisService.getLatestVmCostAnalysis(vmId);
        if (analysis == null) {
            log.info("No VM cost analysis found for VM: {}, run analyzeAllVmCosts mutation first", vmId);
        }
        return analysis;
    }

    @QueryMapping
    public List<AIVmCostAnalysis> getAllVmCostAnalyses() {
        log.info("Fetching all VM cost analyses");
        return vmCostAnalysisService.getAllLatestVmCostAnalyses();
    }

    @MutationMapping
    public String analyzeAllVmCosts() {
        log.info("Manual trigger: Analyzing all VMs costs one by one");
        vmCostAnalysisService.analyzeAllVmsCosts();
        return "VM cost analysis completed for all VMs";
    }
}