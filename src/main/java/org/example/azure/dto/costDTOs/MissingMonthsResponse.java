package org.example.azure.dto.costDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MissingMonthsResponse {
    private List<MonthResult> results;
    private int totalMonthsProcessed;
    private int monthsSynced;
    private int monthsAlreadyPresent;
    private int errors;
}
