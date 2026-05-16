package org.example.ai.repository;

import org.example.ai.entity.AICpuRamAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.util.Optional;

public interface AICpuRamAnalysisRepository extends JpaRepository<AICpuRamAnalysis, Long> {
    Optional<AICpuRamAnalysis> findTopByVmIdOrderByCreatedAtDesc(Long vmId);

    @Modifying
    @Transactional
    @Query("DELETE FROM AICpuRamAnalysis a WHERE a.vmId = :vmId")
    void deleteByVmId(@Param("vmId") Long vmId);
}