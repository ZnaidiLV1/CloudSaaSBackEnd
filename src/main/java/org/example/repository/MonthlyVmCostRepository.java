package org.example.repository;

import org.example.entity.MonthlyVmCost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface MonthlyVmCostRepository extends JpaRepository<MonthlyVmCost, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM MonthlyVmCost m WHERE m.month = :month AND m.year = :year")
    void deleteByMonthAndYear(int month, int year);

    @Query("SELECT m FROM MonthlyVmCost m WHERE m.year = :year AND m.month = :month")
    List<MonthlyVmCost> findByMonthAndYear(@Param("year") int year, @Param("month") int month);

    
    @Query("SELECT MAX(m.year * 100 + m.month) FROM MonthlyVmCost m")
    Integer findNewestYearMonth();

    
    @Query("SELECT MIN(m.year * 100 + m.month) FROM MonthlyVmCost m")
    Integer findOldestYearMonth();

    @Query("SELECT m FROM MonthlyVmCost m WHERE m.year = :year AND m.month = :month")
    List<MonthlyVmCost> findByYearAndMonth(@Param("year") int year, @Param("month") int month);

    @Query("SELECT m FROM MonthlyVmCost m WHERE m.year = :year")
    List<MonthlyVmCost> findByYear(@Param("year") int year);

    @Query("SELECT m FROM MonthlyVmCost m WHERE m.month = :month")
    List<MonthlyVmCost> findByMonth(@Param("month") int month);

    @Query("SELECT m FROM MonthlyVmCost m WHERE (m.year * 100 + m.month) BETWEEN :startYearMonth AND :endYearMonth ORDER BY m.year DESC, m.month DESC")
    List<MonthlyVmCost> findByYearMonthRange(@Param("startYearMonth") int startYearMonth, @Param("endYearMonth") int endYearMonth);

    
    @Query("SELECT DISTINCT m.year, m.month FROM MonthlyVmCost m ORDER BY m.year DESC, m.month DESC")
    List<Object[]> findDistinctYearMonths();
}