package org.example.ai.repository;

import org.example.ai.entity.AIDiskAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

public interface AIDiskAnalysisRepository extends JpaRepository<AIDiskAnalysis, Long> {
    Optional<AIDiskAnalysis> findTopByVmIdOrderByCreatedAtDesc(Long vmId);

    @Transactional
    void deleteByVmId(Long vmId);
}