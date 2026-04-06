package org.example.repository;

import org.example.entity.MonthlyVmCost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface MonthlyVmCostRepository extends JpaRepository<MonthlyVmCost, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM MonthlyVmCost m WHERE m.month = :month AND m.year = :year")
    void deleteByMonthAndYear(int month, int year);
}