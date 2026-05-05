package org.example.dto.backupDTOS;

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