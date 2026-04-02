package org.example.repository;

import org.example.entity.SchedulerConfigEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SchedulerConfigRepository extends JpaRepository<SchedulerConfigEntity, String> {
}