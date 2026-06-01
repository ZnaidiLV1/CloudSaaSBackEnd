package org.example.azure.repository;

import org.example.azure.entity.Troubleshoot;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TroubleshootRepository extends JpaRepository<Troubleshoot, Long> {

    List<Troubleshoot> findByStoppedAtBetween(LocalDateTime start, LocalDateTime end);
    boolean existsByExecutionId(String executionId);

}