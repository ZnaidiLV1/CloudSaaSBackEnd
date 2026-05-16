package org.example.ai.repository;

import org.example.ai.entity.AIInvoiceAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface AIInvoiceAnalysisRepository extends JpaRepository<AIInvoiceAnalysis, Long> {
    @Modifying
    @Transactional
    @Query("DELETE FROM AIInvoiceAnalysis")
    void deleteAllRecords();
}