package org.example.ai.repository;

import org.example.ai.entity.AIVmCostAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

public interface AIVmCostAnalysisRepository extends JpaRepository<AIVmCostAnalysis, Long> {
    Optional<AIVmCostAnalysis> findTopByVmIdOrderByCreatedAtDesc(Long vmId);

    List<AIVmCostAnalysis> findAllByOrderByVmNameAsc();

    @Modifying
    @Transactional
    @Query("DELETE FROM AIVmCostAnalysis a WHERE a.vmId = :vmId")
    void deleteByVmId(@Param("vmId") Long vmId);
}