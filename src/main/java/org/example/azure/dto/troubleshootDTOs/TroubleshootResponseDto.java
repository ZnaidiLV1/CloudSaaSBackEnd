package org.example.azure.dto.troubleshootDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TroubleshootResponseDto {
    private Long id;
    private Long vmId;
    private String summary;
    private String severity;
    private String action;
    private ComponentsDto components;
    private LocalDateTime createdAt;
    private LocalDateTime stoppedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ComponentsDto {
        private ComponentDetailDto spring_boot;
        private ComponentDetailDto syslog;
        private ComponentDetailDto pm2;
        private ComponentDetailDto nginx;
        private ComponentDetailDto postgresql;
        private SystemDetailDto system;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ComponentDetailDto {
        private String status;
        private String details;
        private String suggestion;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SystemDetailDto {
        private String uptime;
        private String memory;
        private String disk;
        private String cpu;
        private String network;
        private String status;
        private String details;
        private String suggestion;
    }
}