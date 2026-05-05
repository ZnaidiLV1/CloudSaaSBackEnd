package org.example.repository;

import org.example.entity.ProtectedItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProtectedItemRepository extends JpaRepository<ProtectedItem, Long> {
    Optional<ProtectedItem> findByBackupInstanceId(String backupInstanceId);

    List<ProtectedItem> findByVmId(Long vmId);

    @Query("SELECT p FROM ProtectedItem p LEFT JOIN FETCH p.backupVault WHERE p.vm.id = :vmId")
    List<ProtectedItem> findByVmIdWithVault(@Param("vmId") Long vmId);

    List<ProtectedItem> findByBackupVaultIdAndIsActiveTrue(Long vaultId);

    List<ProtectedItem> findByProtectionStatusAndIsActiveTrue(String protectionStatus);

    @Modifying
    @Query("UPDATE ProtectedItem p SET p.isActive = false, p.removedAt = CURRENT_TIMESTAMP WHERE p.backupVault.id = :vaultId AND p.isActive = true")
    void deactivateAllByVaultId(@Param("vaultId") Long vaultId);

}