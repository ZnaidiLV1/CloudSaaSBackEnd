package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.entity.AIDiskAnalysis;
import org.example.ai.service.AIDiskAnalysisService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AIDiskResolver {

    private final AIDiskAnalysisService diskAnalysisService;

    @QueryMapping
    public AIDiskAnalysis getDiskAnalysis(@Argument Long vmId) {
        log.info("Fetching disk analysis for VM: {}", vmId);
        AIDiskAnalysis analysis = diskAnalysisService.getLatestAnalysis(vmId);
        if (analysis == null) {
            log.info("No analysis found for VM: {}, triggering analysis", vmId);
        }
        return analysis;
    }

    @MutationMapping
    public String analyzeAllVmsDisks() {
        log.info("Manual trigger: Analyzing all VMs disks");
        diskAnalysisService.analyzeAllVms();
        return "Analysis completed for all VMs";
    }
}