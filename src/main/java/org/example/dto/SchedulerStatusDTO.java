package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SchedulerStatusDTO {
    private String cronExpression;
    private LocalDateTime lastExecution;
    private String lastStatus;
    private LocalDateTime nextExecution;
}