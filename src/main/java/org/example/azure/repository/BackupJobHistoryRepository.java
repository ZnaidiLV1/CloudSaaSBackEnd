package org.example.azure.repository;

import org.example.azure.entity.BackupJobHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface BackupJobHistoryRepository extends JpaRepository<BackupJobHistory, Long> {
    Optional<BackupJobHistory> findByJobId(String jobId);

    List<BackupJobHistory> findByProtectedItemIdOrderByStartTimeDesc(Long protectedItemId);

    List<BackupJobHistory> findByProtectedItemIdAndStartTimeBetweenOrderByStartTimeDesc(
            Long protectedItemId, LocalDateTime start, LocalDateTime end);
    boolean existsByProtectedItemIdAndStartTimeBetween(Long protectedItemId, LocalDateTime start, LocalDateTime end);

    @Query("SELECT j FROM BackupJobHistory j WHERE j.protectedItem.vm.id = (SELECT v.id FROM Vm v WHERE v.name = :vmName) ORDER BY j.startTime DESC")
    List<BackupJobHistory> findRecentJobsByVmName(@Param("vmName") String vmName);

    List<BackupJobHistory> findByProtectedItemId(Long protectedItemId);

    @Query("SELECT b FROM BackupJobHistory b WHERE b.protectedItem.vm.id = :vmId AND b.startTime BETWEEN :startDate AND :endDate ORDER BY b.startTime DESC")
    List<BackupJobHistory> findByVmIdAndStartTimeBetween(@Param("vmId") Long vmId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COALESCE(COUNT(b), 0), COALESCE(SUM(CASE WHEN b.status = 'Completed' THEN 1 ELSE 0 END), 0) FROM BackupJobHistory b WHERE b.protectedItem.id = :protectedItemId AND b.startTime BETWEEN :startDate AND :endDate")
    List<Object[]> getBackupStatsByProtectedItemIdAndDateRange(@Param("protectedItemId") Long protectedItemId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);

    @Query("SELECT " +
            "b.protectedItem.vm.id as vmId, " +
            "b.protectedItem.vm.name as vmName, " +
            "COUNT(b) as totalBackups, " +
            "SUM(CASE WHEN b.status = 'Completed' THEN 1 ELSE 0 END) as completedBackups " +
            "FROM BackupJobHistory b " +
            "WHERE b.startTime BETWEEN :startDate AND :endDate " +
            "AND b.protectedItem.vm.id IS NOT NULL " +
            "GROUP BY b.protectedItem.vm.id, b.protectedItem.vm.name")
    List<Object[]> getBackupStatsGroupedByVm(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}