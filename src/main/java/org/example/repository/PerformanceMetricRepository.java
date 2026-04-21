package org.example.repository;

import org.example.entity.PerformanceMetric;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface PerformanceMetricRepository extends JpaRepository<PerformanceMetric, Long> {

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

    @Query("SELECT FUNCTION('DATE', p.savedAt), SUM(p.diskRead) FROM PerformanceMetric p " +
            "WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :startDate AND :endDate " +
            "GROUP BY FUNCTION('DATE', p.savedAt) ORDER BY FUNCTION('DATE', p.savedAt) ASC")
    List<Object[]> sumDiskReadByDate(@Param("vmId") Long vmId,
                                     @Param("startDate") LocalDateTime startDate,
                                     @Param("endDate") LocalDateTime endDate);

    @Query("SELECT FUNCTION('DATE', p.savedAt), SUM(p.diskWrite) FROM PerformanceMetric p " +
            "WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :startDate AND :endDate " +
            "GROUP BY FUNCTION('DATE', p.savedAt) ORDER BY FUNCTION('DATE', p.savedAt) ASC")
    List<Object[]> sumDiskWriteByDate(@Param("vmId") Long vmId,
                                      @Param("startDate") LocalDateTime startDate,
                                      @Param("endDate") LocalDateTime endDate);

    @Query("SELECT FUNCTION('DATE', p.savedAt), SUM(p.networkIn) FROM PerformanceMetric p " +
            "WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :startDate AND :endDate " +
            "GROUP BY FUNCTION('DATE', p.savedAt) ORDER BY FUNCTION('DATE', p.savedAt) ASC")
    List<Object[]> sumNetworkInByDate(@Param("vmId") Long vmId,
                                      @Param("startDate") LocalDateTime startDate,
                                      @Param("endDate") LocalDateTime endDate);

    @Query("SELECT FUNCTION('DATE', p.savedAt), SUM(p.networkOut) FROM PerformanceMetric p " +
            "WHERE p.vm.id = :vmId AND p.savedAt BETWEEN :startDate AND :endDate " +
            "GROUP BY FUNCTION('DATE', p.savedAt) ORDER BY FUNCTION('DATE', p.savedAt) ASC")
    List<Object[]> sumNetworkOutByDate(@Param("vmId") Long vmId,
                                       @Param("startDate") LocalDateTime startDate,
                                       @Param("endDate") LocalDateTime endDate);




}