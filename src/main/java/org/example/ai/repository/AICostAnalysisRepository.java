package org.example.ai.repository;

import org.example.ai.entity.AICostAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

public interface AICostAnalysisRepository extends JpaRepository<AICostAnalysis, Long> {
    @Modifying
    @Transactional
    @Query("DELETE FROM AICostAnalysis")
    void deleteAllRecords();
}