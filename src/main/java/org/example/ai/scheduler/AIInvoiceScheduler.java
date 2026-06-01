package org.example.ai.scheduler;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.service.AIInvoiceAnalysisService;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@EnableScheduling
@Slf4j
public class AIInvoiceScheduler {
    private final AIInvoiceAnalysisService invoiceAnalysisService;

    @Scheduled(cron = "0 0 14 12 * *")
    public void runMonthlyInvoiceAnalysis() {
        log.info("Starting monthly invoice analysis");
        try {
            invoiceAnalysisService.analyzeInvoices();
            log.info("Monthly invoice analysis completed successfully");
        } catch (Exception e) {
            log.error("Monthly invoice analysis failed: {}", e.getMessage());
        }
    }
}