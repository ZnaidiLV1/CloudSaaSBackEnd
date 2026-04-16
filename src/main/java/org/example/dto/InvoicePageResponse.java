package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InvoicePageResponse {
    private List<InvoiceSummaryDto> invoices;
    private int index;
    private boolean hasNext;
    private boolean hasPrevious;
}
