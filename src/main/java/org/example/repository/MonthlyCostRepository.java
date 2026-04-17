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

    @Query("SELECT m.serviceName, SUM(m.cost) FROM MonthlyCost m " +
            "WHERE m.month = :month AND m.year = :year " +
            "GROUP BY m.serviceName")
    List<Object[]> sumCostsByService(@Param("month") int month, @Param("year") int year);

    @Query("SELECT m.meterName, SUM(m.cost) FROM MonthlyCost m " +
            "WHERE m.month = :month AND m.year = :year " +
            "GROUP BY m.meterName")
    List<Object[]> sumCostsByMeter(@Param("month") int month, @Param("year") int year);

    List<MonthlyCost> findByMonthAndYear(int month, int year);

}