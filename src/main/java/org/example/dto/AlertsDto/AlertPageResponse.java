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
public class AlertPageResponse {
    private List<AlertDto> alerts;
    private String vmName;
    private Integer index;
    private Boolean hasNext;
    private Boolean hasPrevious;
    private Integer totalCount;
}