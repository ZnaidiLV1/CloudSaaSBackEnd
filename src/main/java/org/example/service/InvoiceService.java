package org.example.service;

import com.azure.core.credential.AccessToken;
import com.azure.core.credential.TokenCredential;
import com.azure.core.credential.TokenRequestContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.CostAmountsResponse;
import org.example.dto.InvoiceDto;
import org.example.dto.InvoicePageResponse;
import org.example.dto.InvoiceSummaryDto;
import org.example.entity.Invoice;
import org.example.repository.InvoiceRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class InvoiceService {

    private final TokenCredential credential;
    private final InvoiceRepository invoiceRepository;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${azure.billing-account-id}")
    private String billingAccountId;

    @Value("${azure.billing-profile-id}")
    private String billingProfileId;

    private String getToken() {
        AccessToken token = credential.getToken(
                new TokenRequestContext()
                        .addScopes("https://management.azure.com/.default")
        ).block();
        assert token != null;
        return token.getToken();
    }

    public InvoicePageResponse getInvoicesBySmartIndex(int index) {
        int monthsPerPage = 6;

        LocalDateTime newestDate = invoiceRepository.findNewestInvoiceDate();
        LocalDateTime oldestDate = invoiceRepository.findOldestInvoiceDate();

        if (newestDate == null) {
            return InvoicePageResponse.builder()
                    .invoices(List.of())
                    .index(index)
                    .hasNext(false)
                    .hasPrevious(false)
                    .build();
        }


        LocalDateTime windowEnd = newestDate.minusMonths(monthsPerPage * index);
        LocalDateTime windowStart = windowEnd.minusMonths(monthsPerPage);


        boolean hasNext = windowStart.minusMonths(1).isAfter(oldestDate) || windowStart.isAfter(oldestDate);
        boolean hasPrevious = index > 0;


        List<Invoice> invoices = invoiceRepository.findInvoicesBetweenDates(windowStart, windowEnd);

        List<InvoiceSummaryDto> summaryDtos = invoices.stream()
                .map(inv -> InvoiceSummaryDto.builder()
                        .invoiceId(inv.getInvoiceId())
                        .status(inv.getStatus())
                        .totalAmount(inv.getTotalAmount())
                        .monthYear(inv.getInvoiceDate().getMonth().toString() + " " + inv.getInvoiceDate().getYear())
                        .build())
                .collect(Collectors.toList());

        return InvoicePageResponse.builder()
                .invoices(summaryDtos)
                .index(index)
                .hasNext(hasNext)
                .hasPrevious(hasPrevious)
                .build();
    }

    public List<InvoiceDto> getInvoicesForMonth(int year, int month) {
        try {
            String raw = fetchInvoicesRaw();
            return parseAndFilter(raw, year, month);

        } catch (Exception e) {
            log.error("Error fetching invoices", e);
            throw new RuntimeException(e.getMessage());
        }
    }

    /**
     * Fetch and save invoices from current month (February 2026) going back 12 months
     */
    public String saveLast12MonthsInvoices() {
        try {

            LocalDate currentMonth = LocalDate.of(2026, 2, 1);


            LocalDate startMonth = currentMonth.minusMonths(11);

            String raw = fetchInvoicesRaw();

            int savedCount = 0;
            int skippedCount = 0;


            LocalDate monthIterator = startMonth;
            while (!monthIterator.isAfter(currentMonth)) {
                int year = monthIterator.getYear();
                int month = monthIterator.getMonthValue();

                log.info("Fetching invoices for {}-{}", year, month);

                List<InvoiceDto> invoices = parseAndFilter(raw, year, month);

                for (InvoiceDto dto : invoices) {
                    if (invoiceRepository.findByInvoiceId(dto.getInvoiceId()).isPresent()) {
                        log.info("Invoice {} already exists, skipping", dto.getInvoiceId());
                        skippedCount++;
                        continue;
                    }

                    Invoice invoice = Invoice.builder()
                            .invoiceId(dto.getInvoiceId())
                            .invoiceName(dto.getInvoiceName())
                            .status(dto.getStatus())
                            .invoiceDate(parseDate(dto.getInvoiceDate()))
                            .dueDate(parseDate(dto.getDueDate()))
                            .billingPeriodStart(parseDate(dto.getBillingPeriodStart()))
                            .billingPeriodEnd(parseDate(dto.getBillingPeriodEnd()))
                            .totalAmount(dto.getTotalAmount())
                            .amountDue(dto.getAmountDue())
                            .currency(dto.getCurrency())
                            .downloadUrl(dto.getDownloadUrl())
                            .build();

                    invoiceRepository.save(invoice);
                    savedCount++;
                    log.info("Saved invoice {} for {}-{}", dto.getInvoiceId(), year, month);
                }

                monthIterator = monthIterator.plusMonths(1);
            }

            log.info("Completed: Saved {} invoices, Skipped {} existing invoices", savedCount, skippedCount);
            return String.format("Saved %d invoices for last 12 months (from %s to %s)",
                    savedCount, startMonth, currentMonth);

        } catch (Exception e) {
            log.error("Error saving last 12 months invoices", e);
            return "error: " + e.getMessage();
        }
    }

    public CostAmountsResponse getCostAmounts(int startMonth, int startYear, int endMonth, int endYear) {
        LocalDateTime startDate = LocalDateTime.of(startYear, startMonth, 1, 0, 0);
        LocalDateTime endDate = LocalDateTime.of(endYear, endMonth, 1, 0, 0);

        List<Invoice> invoices = invoiceRepository.findInvoicesByBillingPeriodStartBetween(startDate, endDate);

        List<Double> amounts = new ArrayList<>();
        List<String> months = new ArrayList<>();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/yy");

        for (Invoice invoice : invoices) {
            amounts.add(invoice.getTotalAmount());
            String monthYear = invoice.getBillingPeriodStart().format(formatter);
            months.add(monthYear);
        }

        return CostAmountsResponse.builder()
                .amounts(amounts)
                .months(months)
                .build();
    }

    public String saveInvoicesFromDateRange(int startYear, int startMonth, int endYear, int endMonth) {
        try {
            LocalDate start = LocalDate.of(startYear, startMonth, 1);
            LocalDate end = LocalDate.of(endYear, endMonth, 1);

            String raw = fetchInvoicesRaw();

            int savedCount = 0;
            int skippedCount = 0;

            LocalDate monthIterator = start;
            while (!monthIterator.isAfter(end)) {
                int year = monthIterator.getYear();
                int month = monthIterator.getMonthValue();

                List<InvoiceDto> invoices = parseAndFilter(raw, year, month);

                for (InvoiceDto dto : invoices) {
                    if (invoiceRepository.findByInvoiceId(dto.getInvoiceId()).isPresent()) {
                        skippedCount++;
                        continue;
                    }

                    Invoice invoice = Invoice.builder()
                            .invoiceId(dto.getInvoiceId())
                            .invoiceName(dto.getInvoiceName())
                            .status(dto.getStatus())
                            .invoiceDate(parseDate(dto.getInvoiceDate()))
                            .dueDate(parseDate(dto.getDueDate()))
                            .billingPeriodStart(parseDate(dto.getBillingPeriodStart()))
                            .billingPeriodEnd(parseDate(dto.getBillingPeriodEnd()))
                            .totalAmount(dto.getTotalAmount())
                            .amountDue(dto.getAmountDue())
                            .currency(dto.getCurrency())
                            .downloadUrl(dto.getDownloadUrl())
                            .build();

                    invoiceRepository.save(invoice);
                    savedCount++;
                }

                monthIterator = monthIterator.plusMonths(1);
            }

            return String.format("Saved %d invoices from %d-%d to %d-%d",
                    savedCount, startYear, startMonth, endYear, endMonth);

        } catch (Exception e) {
            log.error("Error saving invoices from date range", e);
            return "error: " + e.getMessage();
        }
    }

    public String savePreviousMonthInvoice() {
        try {
            LocalDate previous = LocalDate.now().minusMonths(1);

            int year = previous.getYear();
            int month = previous.getMonthValue();

            String raw = fetchInvoicesRaw();

            List<InvoiceDto> invoices = parseAndFilter(raw, year, month);

            for (InvoiceDto dto : invoices) {

                if (invoiceRepository.findByInvoiceId(dto.getInvoiceId()).isPresent()) {
                    log.info("Invoice {} already exists", dto.getInvoiceId());
                    continue;
                }

                Invoice invoice = Invoice.builder()
                        .invoiceId(dto.getInvoiceId())
                        .invoiceName(dto.getInvoiceName())
                        .status(dto.getStatus())
                        .invoiceDate(parseDate(dto.getInvoiceDate()))
                        .dueDate(parseDate(dto.getDueDate()))
                        .billingPeriodStart(parseDate(dto.getBillingPeriodStart()))
                        .billingPeriodEnd(parseDate(dto.getBillingPeriodEnd()))
                        .totalAmount(dto.getTotalAmount())
                        .amountDue(dto.getAmountDue())
                        .currency(dto.getCurrency())
                        .downloadUrl(dto.getDownloadUrl())
                        .build();

                invoiceRepository.save(invoice);
            }

            return "done";

        } catch (Exception e) {
            log.error("Error saving previous month invoice", e);
            return "error";
        }
    }

    private String fetchInvoicesRaw() {
        String token = getToken();
        WebClient client = WebClient.builder().build();


        LocalDate start = LocalDate.now().minusMonths(18);
        LocalDate end = LocalDate.now().plusMonths(1);

        String url = "https://management.azure.com"
                + "/providers/Microsoft.Billing/billingAccounts/" + billingAccountId
                + "/billingProfiles/" + billingProfileId
                + "/invoices"
                + "?periodStartDate=" + start
                + "&periodEndDate=" + end
                + "&api-version=2024-04-01";

        return client.get()
                .uri(url)
                .headers(h -> h.setBearerAuth(token))
                .retrieve()
                .bodyToMono(String.class)
                .block();
    }

    private List<InvoiceDto> parseAndFilter(String raw, int year, int month) throws Exception {
        JsonNode root = objectMapper.readTree(raw);
        JsonNode values = root.get("value");

        List<InvoiceDto> result = new ArrayList<>();

        String targetPrefix = String.format("%04d-%02d", year, month);

        for (JsonNode inv : values) {

            JsonNode props = inv.get("properties");
            if (props == null) continue;

            String periodStart = textOrNull(props, "invoicePeriodStartDate");

            if (periodStart == null) continue;
            if (!periodStart.startsWith(targetPrefix)) continue;

            String downloadUrl = null;
            JsonNode docs = props.get("documents");

            if (docs != null && docs.isArray() && !docs.isEmpty()) {
                downloadUrl = textOrNull(docs.get(0), "url");
            }

            result.add(
                    InvoiceDto.builder()
                            .invoiceId(textOrNull(inv, "name"))
                            .invoiceName(textOrNull(props, "invoiceNumber"))
                            .status(textOrNull(props, "status"))
                            .invoiceDate(textOrNull(props, "invoiceDate"))
                            .dueDate(textOrNull(props, "dueDate"))
                            .billingPeriodStart(periodStart)
                            .billingPeriodEnd(textOrNull(props, "invoicePeriodEndDate"))
                            .totalAmount(nestedDouble(props, "billedAmount", "value"))
                            .amountDue(nestedDouble(props, "amountDue", "value"))
                            .currency(nestedText(props, "amountDue", "currency"))
                            .downloadUrl(downloadUrl)
                            .build()
            );
        }

        return result;
    }

    private LocalDateTime parseDate(String val) {
        if (val == null) return null;
        return LocalDateTime.parse(val, DateTimeFormatter.ISO_DATE_TIME);
    }

    private String textOrNull(JsonNode node, String field) {
        if (node == null) return null;
        JsonNode f = node.get(field);
        return (f == null || f.isNull()) ? null : f.asText();
    }

    private String nestedText(JsonNode node, String parent, String child) {
        JsonNode p = node.get(parent);
        if (p == null) return null;
        JsonNode c = p.get(child);
        return c == null ? null : c.asText();
    }

    private Double nestedDouble(JsonNode node, String parent, String child) {
        JsonNode p = node.get(parent);
        if (p == null) return null;
        JsonNode c = p.get(child);
        return c == null ? null : c.asDouble();
    }
}