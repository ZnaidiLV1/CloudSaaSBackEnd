package org.example.repository;

import org.example.entity.PerformanceMetric;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface PerformanceMetricRepository extends JpaRepository<PerformanceMetric, Long> {

    // 1. Get all metrics for a VM in a time range, ordered by time
    List<PerformanceMetric> findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(Long vmId, LocalDateTime from, LocalDateTime to);

    // 2. Get the latest metric for a VM (most recent)
    PerformanceMetric findTopByVmIdOrderBySavedAtDesc(Long vmId);

    // 3. Get all metrics for a time range (used by AvailabilityService)
    List<PerformanceMetric> findBySavedAtBetween(LocalDateTime start, LocalDateTime end);

    // 4. Find downtime hours (when availability was less than 100%)
    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.availabilityPercent < 100.0 ORDER BY p.savedAt DESC")
    List<PerformanceMetric> findDowntimeHours(@Param("vmId") Long vmId);

    // 5. Find CPU spike hours (CPU exceeded threshold)
    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.cpuMax >= :threshold AND p.savedAt BETWEEN :from AND :to")
    List<PerformanceMetric> findCpuSpikeHours(@Param("vmId") Long vmId,
                                              @Param("threshold") Double threshold,
                                              @Param("from") LocalDateTime from,
                                              @Param("to") LocalDateTime to);

    // 6. Calculate average availability for a VM in a time range
    @Query("SELECT AVG(p.availabilityPercent) FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :from AND :to")
    Double avgAvailability(@Param("vmId") Long vmId,
                           @Param("from") LocalDateTime from,
                           @Param("to") LocalDateTime to);
}