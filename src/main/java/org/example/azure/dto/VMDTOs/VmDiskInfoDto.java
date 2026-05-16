package org.example.azure.dto.VMDTOs;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VmDiskInfoDto {
    private String vmName;
    private String workspaceName;
    private Double diskFreePercent;
    private Double diskFreeMB;
    private Double diskFreeGB;
    private LocalDateTime diskLastUpdated;
}