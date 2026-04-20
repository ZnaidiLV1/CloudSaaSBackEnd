package org.example.dto.AlertsDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlertDto {
    private String alertName;
    private LocalDateTime occurredAt;
    private String monitorCondition;
    private String description;
    private String vmName;
}