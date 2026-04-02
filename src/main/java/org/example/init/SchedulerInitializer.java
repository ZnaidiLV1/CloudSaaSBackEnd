package org.example.init;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.scheduler.*;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class SchedulerInitializer {

    private final PerformanceScheduler performanceScheduler;
    private final CostScheduler costScheduler;
    private final InvoiceScheduler invoiceScheduler;
    private final InfraScheduler infraScheduler;
    private final AlertScheduler alertScheduler;
    private final MonthlyCostScheduler monthlyCostScheduler;

 /*   @EventListener(ApplicationReadyEvent.class)
    public void initializeAllSchedulers() {
        log.info("=== Initializing all schedulers after database load ===");

        performanceScheduler.initialize();
        costScheduler.initialize();
        invoiceScheduler.initialize();
        infraScheduler.initialize();
        alertScheduler.initialize();
        monthlyCostScheduler.initialize();

        log.info("=== All schedulers initialized successfully ===");
    }*/
}