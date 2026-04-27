package org.example.dto.AlertsDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AlertDto {
    private String alertName;
    private String occurredAt;      
    private String monitorCondition; 
    private String description;
    private String vmName;
    private Double metricValue;      
    private String resolvedAt;       
    private String duration;         
}