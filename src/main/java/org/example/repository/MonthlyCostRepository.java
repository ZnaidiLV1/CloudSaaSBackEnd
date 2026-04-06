package org.example.repository;

import org.example.entity.MonthlyCost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

public interface MonthlyCostRepository extends JpaRepository<MonthlyCost, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM MonthlyCost m WHERE m.month = :month AND m.year = :year")
    int deleteByMonthAndYear(@Param("month") int month, @Param("year") int year);

    List<MonthlyCost> findByMonthAndYearOrderByServiceNameAscMeterNameAsc(int month, int year);

    List<MonthlyCost> findByVmIdAndMonthAndYear(Long vmId, int month, int year);

    List<MonthlyCost> findByMonthAndYear(int month, int year);

    List<MonthlyCost> findByIsSharedTrueAndMonthAndYear(int month, int year);

    @Query("SELECT SUM(m.cost) FROM MonthlyCost m WHERE m.vmId = :vmId AND m.month = :month AND m.year = :year")
    BigDecimal getTotalCostForVm(@Param("vmId") Long vmId, @Param("month") int month, @Param("year") int year);
}