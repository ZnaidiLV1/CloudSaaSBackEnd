package org.example.azure.repository;

import org.example.azure.entity.BackupVault;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface BackupVaultRepository extends JpaRepository<BackupVault, Long> {
    Optional<BackupVault> findByVaultName(String vaultName);
}