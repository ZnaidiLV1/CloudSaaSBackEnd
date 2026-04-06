package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SyncCostResult {
    private Boolean success;
    private String message;
    private Integer recordsSaved;
    private Integer month;
    private Integer year;
}