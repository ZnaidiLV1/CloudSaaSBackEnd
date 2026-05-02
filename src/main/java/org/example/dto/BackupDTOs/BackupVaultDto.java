package org.example.dto.BackupDTOs;

import lombok.Data;

@Data
public class BackupVaultDto {
    private String vaultName;
    private String resourceGroup;
    private String location;
    private String storageType;
    private String tags;
}