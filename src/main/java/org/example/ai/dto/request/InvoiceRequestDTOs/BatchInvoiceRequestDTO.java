package org.example.ai.dto.request.InvoiceRequestDTOs;

import lombok.Data;
import java.util.List;

@Data
public class BatchInvoiceRequestDTO {
    private YearlyTotals yearlyTotals;
    private List<MonthlyAmount> last12Months;

    @Data
    public static class YearlyTotals {
        private Double year2024;
        private Double year2025;
        private Double year2026;
    }

    @Data
    public static class MonthlyAmount {
        private String month;
        private Double amount;
    }
}