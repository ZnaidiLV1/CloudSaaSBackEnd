package org.example.azure.dto.BackupDTOs;

import lombok.Data;

import java.util.List;

@Data
public class BackupVaultWithItemsDTO {
    private String vaultName;
    private String resourceGroup;
    private String location;
    private String storageType;
    private List<ProtectedItemInfoDTO> protectedItems;
}