package org.example.repository;

import org.example.entity.AzureAlert;
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
}