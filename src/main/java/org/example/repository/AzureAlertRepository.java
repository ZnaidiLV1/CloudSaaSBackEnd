package org.example.repository;

import org.example.entity.AzureAlert;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDateTime;
import java.util.List;

public interface AzureAlertRepository
        extends JpaRepository<AzureAlert, Long> {

    boolean existsByAzureAlertId(String azureAlertId);

    List<AzureAlert> findByVmIdAndOccurredAtBetweenOrderByOccurredAtDesc(
            Long vmId, LocalDateTime from, LocalDateTime to);

    @Query("SELECT a FROM AzureAlert a " +
            "JOIN a.vm v JOIN v.tags t " +
            "WHERE t.key = 'Product' AND t.value = :product " +
            "AND a.occurredAt BETWEEN :from AND :to " +
            "ORDER BY a.occurredAt DESC")
    List<AzureAlert> findByProductAndPeriod(
            @Param("product") String product,
            @Param("from") LocalDateTime from,
            @Param("to") LocalDateTime to);

    List<AzureAlert> findTop20ByVmIdOrderByOccurredAtDesc(Long vmId);
}