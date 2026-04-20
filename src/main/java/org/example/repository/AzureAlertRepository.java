package org.example.repository;

import org.example.entity.AzureAlert;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AzureAlertRepository extends JpaRepository<AzureAlert, Long> {

    Optional<AzureAlert> findByAzureAlertIdAndVmId(String azureAlertId, Long vmId);

    boolean existsByAzureAlertIdAndVmId(String azureAlertId, Long vmId);

    List<AzureAlert> findByVmIdAndOccurredAtBetween(Long vmId, LocalDateTime start, LocalDateTime end);

    List<AzureAlert> findByMonitorConditionAndOccurredAtBetween(String monitorCondition, LocalDateTime start, LocalDateTime end);

    List<AzureAlert> findByMonitorConditionAndResolvedAtIsNull(String monitorCondition);

    @Query("SELECT a FROM AzureAlert a WHERE a.vm.id = :vmId AND a.azureAlertId = :alertId")
    Optional<AzureAlert> findByVmIdAndAzureAlertId(@Param("vmId") Long vmId, @Param("alertId") String alertId);

    @Query("SELECT a FROM AzureAlert a LEFT JOIN FETCH a.vm WHERE a.vm.id = :vmId")
    Page<AzureAlert> findByVmIdWithVm(@Param("vmId") Long vmId, Pageable pageable);

    @Query("SELECT a FROM AzureAlert a LEFT JOIN FETCH a.vm")
    Page<AzureAlert> findAllWithVm(Pageable pageable);

    Long countByVmId(Long vmId);

    Long countByVmIdAndMonitorCondition(Long vmId, String monitorCondition);

    @Query("SELECT a.alertName, COUNT(a) FROM AzureAlert a WHERE a.vm.id = :vmId GROUP BY a.alertName")
    List<Object[]> countByVmIdGroupByAlertName(@Param("vmId") Long vmId);

    Long countByMonitorCondition(String monitorCondition);

    @Query("SELECT a.alertName, COUNT(a) FROM AzureAlert a GROUP BY a.alertName")
    List<Object[]> countGroupByAlertName();

    @Query("SELECT FUNCTION('DATE', a.occurredAt), COUNT(a) FROM AzureAlert a " +
            "WHERE (:vmId = 0 OR a.vm.id = :vmId) " +
            "AND a.occurredAt BETWEEN :startDate AND :endDate " +
            "GROUP BY FUNCTION('DATE', a.occurredAt)")
    List<Object[]> getAlertCountsByDate(@Param("vmId") Long vmId,
                                        @Param("startDate") LocalDateTime startDate,
                                        @Param("endDate") LocalDateTime endDate);
}