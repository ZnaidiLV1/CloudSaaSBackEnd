package org.example.repository;

import org.example.entity.PerformanceMetric;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface PerformanceMetricRepository extends JpaRepository<PerformanceMetric, Long> {
    PerformanceMetric findTopByVmIdOrderBySavedAtDesc(Long vmId);

    List<PerformanceMetric> findBySavedAtBetween(LocalDateTime start, LocalDateTime end);

    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.availabilityPercent < 100.0 ORDER BY p.savedAt DESC")
    List<PerformanceMetric> findDowntimeHours(@Param("vmId") Long vmId);

    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.cpuMax >= :threshold AND p.savedAt BETWEEN :from AND :to")
    List<PerformanceMetric> findCpuSpikeHours(@Param("vmId") Long vmId,
                                              @Param("threshold") Double threshold,
                                              @Param("from") LocalDateTime from,
                                              @Param("to") LocalDateTime to);

    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :startOfDay AND :endOfDay ORDER BY p.savedAt ASC")
    List<PerformanceMetric> findByVmIdAndSavedAtBetweenOrderBySavedAtAsc(
            @Param("vmId") Long vmId,
            @Param("startOfDay") LocalDateTime startOfDay,
            @Param("endOfDay") LocalDateTime endOfDay
    );

    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :startDate AND :endDate ORDER BY p.savedAt ASC")
    List<PerformanceMetric> findByVmIdAndSavedAtBetween(
            @Param("vmId") Long vmId,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate
    );

    @Query("SELECT p FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :startOfDay AND :endOfDay ORDER BY p.savedAt ASC")
    List<PerformanceMetric> findMetricsByVmIdAndDateRange(
            @Param("vmId") Long vmId,
            @Param("startOfDay") LocalDateTime startOfDay,
            @Param("endOfDay") LocalDateTime endOfDay
    );
    @Query("SELECT AVG(p.availabilityPercent) FROM PerformanceMetric p WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :from AND :to")
    Double avgAvailability(@Param("vmId") Long vmId,
                           @Param("from") LocalDateTime from,
                           @Param("to") LocalDateTime to);




}