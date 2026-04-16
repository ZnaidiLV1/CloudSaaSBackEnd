package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InfrastructureResponse {
    private List<VmDto> vms;
    private List<TagDto> tags;
    private List<VmTagRelationDto> vmTags;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VmDto {
        private Long id;
        private String name;
        private String status;
        private String vmType;
        private String publicIpAddress;
        private String billingType;
        private String region;
        private String resourceGroup;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TagDto {
        private Long id;
        private String key;
        private String value;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class VmTagRelationDto {
        private Long vmId;
        private Long tagId;
    }
}