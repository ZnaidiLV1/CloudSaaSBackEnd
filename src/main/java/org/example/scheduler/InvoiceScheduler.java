package org.example.scheduler;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.InvoiceService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.Locale;

@Component
@RequiredArgsConstructor
@Slf4j
public class InvoiceScheduler {
    private final InvoiceService invoiceService;

    @Scheduled(cron = "0 0 2 11 * *")
    public void pullMonthlyInvoice(){
        log.info("pulling monthly invoice {}",LocalDate.now()
                .getMonth()
                .getDisplayName(TextStyle.FULL, Locale.ENGLISH));
        invoiceService.savePreviousMonthInvoice();
    }
}
