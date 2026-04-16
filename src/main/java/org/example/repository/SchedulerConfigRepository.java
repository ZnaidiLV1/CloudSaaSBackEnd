package org.example.repository;

import org.example.entity.SchedulerConfigEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Repository
public interface SchedulerConfigRepository extends JpaRepository<SchedulerConfigEntity, String> {

    @Modifying
    @Transactional
    @Query("UPDATE SchedulerConfigEntity s SET s.lastExecution = :lastExecution, s.lastStatus = :lastStatus WHERE s.taskName = :taskName")
    void updateExecutionStatus(@Param("taskName") String taskName,
                               @Param("lastExecution") LocalDateTime lastExecution,
                               @Param("lastStatus") String lastStatus);

    @Modifying
    @Transactional
    @Query("UPDATE SchedulerConfigEntity s SET s.lastStatus = :lastStatus WHERE s.taskName = :taskName")
    void updateStatusOnly(@Param("taskName") String taskName,
                          @Param("lastStatus") String lastStatus);
}