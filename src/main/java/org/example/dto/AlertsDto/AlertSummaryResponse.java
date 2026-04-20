package org.example.dto.AlertsDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlertSummaryResponse {
    private Long vmId;
    private String vmName;
    private List<AlertGroupDto> alertGroups;
    private Long firedCount;
    private Long resolvedCount;
    private Long totalCount;
}