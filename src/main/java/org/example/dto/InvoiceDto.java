package org.example.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InvoiceDto {
    private String invoiceId;
    private String invoiceName;
    private String status;
    private String invoiceDate;
    private String dueDate;
    private String billingPeriodStart;
    private String billingPeriodEnd;
    private Double totalAmount;
    private Double amountDue;
    private String currency;
    private String downloadUrl;
}