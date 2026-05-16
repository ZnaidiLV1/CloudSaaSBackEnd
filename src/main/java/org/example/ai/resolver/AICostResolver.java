package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.entity.AICostAnalysis;
import org.example.ai.service.AICostAnalysisService;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AICostResolver {
    private final AICostAnalysisService costAnalysisService;

    @QueryMapping
    public AICostAnalysis getLatestCostAnalysis() {
        log.info("Fetching latest cost analysis");
        AICostAnalysis analysis = costAnalysisService.getLatestCostAnalysis();
        if (analysis == null) {
            log.info("No cost analysis found, triggering analysis");
            costAnalysisService.analyzeCosts();
            analysis = costAnalysisService.getLatestCostAnalysis();
        }
        return analysis;
    }

    @MutationMapping
    public String analyzeCosts() {
        log.info("Manual trigger: Analyzing costs");
        costAnalysisService.analyzeCosts();
        return "Cost analysis completed";
    }
}