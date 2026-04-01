package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.InvoiceDto;
import org.example.service.InvoiceService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class InvoiceResolver {

    private final InvoiceService invoiceService;

    @QueryMapping
    public List<InvoiceDto> invoicesForMonth(
            @Argument int year,
            @Argument int month
    ) {
        return invoiceService.getInvoicesForMonth(year, month);
    }

    @MutationMapping
    public String savePreviousMonthInvoice() {
        return invoiceService.savePreviousMonthInvoice();
    }
}