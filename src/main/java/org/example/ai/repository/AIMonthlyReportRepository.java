package org.example.ai.repository;

import org.example.ai.entity.AIMonthlyReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface AIMonthlyReportRepository extends JpaRepository<AIMonthlyReport, Long> {
    @Modifying
    @Transactional
    @Query("DELETE FROM AIMonthlyReport")
    void deleteAllRecords();

    Optional<AIMonthlyReport> findTopByOrderByCreatedAtDesc();

}