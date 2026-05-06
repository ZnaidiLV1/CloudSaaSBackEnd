package org.example.repository;

import org.example.entity.BackupJobHistory;
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
}