package org.example.repository;

import org.example.entity.PerformanceMetric;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface PerformanceMetricRepository extends JpaRepository<PerformanceMetric, Long> {

    List<PerformanceMetric> findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(Long vmId, LocalDateTime from, LocalDateTime to);
    PerformanceMetric findTopByVmIdOrderBySavedAtDesc(Long vmId);

    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.availabilityPercent < 100.0 ORDER BY p.savedAt DESC")
    List<PerformanceMetric> findDowntimeHours(@Param("vmId") Long vmId);

    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.cpuMax >= :threshold AND p.savedAt BETWEEN :from AND :to")
    List<PerformanceMetric> findCpuSpikeHours(@Param("vmId") Long vmId,
                                              @Param("threshold") Double threshold,
                                              @Param("from") LocalDateTime from,
                                              @Param("to") LocalDateTime to);

    @Query("SELECT AVG(p.availabilityPercent) FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :from AND :to")
    Double avgAvailability(@Param("vmId") Long vmId,
                           @Param("from") LocalDateTime from,
                           @Param("to") LocalDateTime to);
}