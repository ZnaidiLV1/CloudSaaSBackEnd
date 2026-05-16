package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.entity.AIInvoiceAnalysis;
import org.example.ai.service.AIInvoiceAnalysisService;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
@Slf4j
public class AIInvoiceResolver {
    private final AIInvoiceAnalysisService invoiceAnalysisService;

    @QueryMapping
    public AIInvoiceAnalysis getLatestInvoiceAnalysis() {
        log.info("Fetching latest invoice analysis");
        AIInvoiceAnalysis analysis = invoiceAnalysisService.getLatestInvoiceAnalysis();
        if (analysis == null) {
            log.info("No invoice analysis found, triggering analysis");
        }
        return analysis;
    }

    @MutationMapping
    public String analyzeInvoices() {
        log.info("Manual trigger: Analyzing invoices");
        invoiceAnalysisService.analyzeInvoices();
        return "Invoice analysis completed";
    }
}