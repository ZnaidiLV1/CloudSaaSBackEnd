package org.example.ai.dto.request.AlertRequestDTOs;

import lombok.Data;
import java.util.List;

@Data
public class BatchAlertRequestDTO {
    private List<VmAlertData> vms;

    @Data
    public static class VmAlertData {
        private Long vmId;
        private String vmName;
        private List<AlertDetail> alerts;
    }

    @Data
    public static class AlertDetail {
        private String alertName;
        private String description;
        private String occurredAt;
        private Double metricValue;
        private String resolvedAt;
        private Long durationSeconds;
        private String monitorCondition;
    }
}