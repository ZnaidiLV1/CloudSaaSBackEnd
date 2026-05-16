package org.example.azure.dto.costDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MonthResult {
    private int month;
    private int year;
    private String status;
    private String message;
}