package org.example.repository;

import org.example.entity.CostRecord;
import org.example.enums.CostType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDate;
import java.util.List;

public interface CostRecordRepository extends JpaRepository<CostRecord, Long> {

    List<CostRecord> findByVmIdAndDate(Long vmId, LocalDate date);

    List<CostRecord> findByVmIdAndDateBetween(
            Long vmId, LocalDate from, LocalDate to);

    @Query("SELECT SUM(c.amount) FROM CostRecord c " +
            "WHERE c.vm.id = :vmId " +
            "AND c.date BETWEEN :from AND :to")
    Double totalCostByVmAndPeriod(
            @Param("vmId") Long vmId,
            @Param("from") LocalDate from,
            @Param("to") LocalDate to);

    @Query("SELECT c.costType, SUM(c.amount) FROM CostRecord c " +
            "JOIN c.vm v JOIN v.tags t " +
            "WHERE t.key = 'Product' AND t.value = :product " +
            "AND c.date BETWEEN :from AND :to " +
            "GROUP BY c.costType")
    List<Object[]> totalCostByTypeAndProduct(
            @Param("product") String product,
            @Param("from") LocalDate from,
            @Param("to") LocalDate to);

    @Query("SELECT c.date, SUM(c.amount) FROM CostRecord c " +
            "JOIN c.vm v JOIN v.tags t " +
            "WHERE t.key = 'Product' AND t.value = :product " +
            "AND c.date BETWEEN :from AND :to " +
            "GROUP BY c.date ORDER BY c.date")
    List<Object[]> dailyCostByProduct(
            @Param("product") String product,
            @Param("from") LocalDate from,
            @Param("to") LocalDate to);
}