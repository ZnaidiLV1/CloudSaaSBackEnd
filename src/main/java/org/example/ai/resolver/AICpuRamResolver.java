package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.entity.AICpuRamAnalysis;
import org.example.ai.service.AICpuRamAnalysisService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AICpuRamResolver {
    private final AICpuRamAnalysisService cpuRamAnalysisService;

    @QueryMapping
    public AICpuRamAnalysis getCpuRamAnalysis(@Argument Long vmId) {
        log.info("Fetching CPU/RAM analysis for VM: {}", vmId);
        AICpuRamAnalysis analysis = cpuRamAnalysisService.getLatestCpuRamAnalysis(vmId);
        if (analysis == null) {
            log.info("No CPU/RAM analysis found for VM: {}, triggering analysis", vmId);
        }
        return analysis;
    }

    @MutationMapping
    public String analyzeAllVmsCpuRam() {
        log.info("Manual trigger: Analyzing all VMs CPU/RAM");
        cpuRamAnalysisService.analyzeAllVmsCpuRam();
        return "CPU/RAM analysis completed for all VMs";
    }
}