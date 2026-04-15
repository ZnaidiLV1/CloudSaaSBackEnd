package org.example.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.time.LocalDateTime;

@Data
@Entity
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "scheduler_config")
public class SchedulerConfigEntity {

    @Id
    private String taskName;
    private String cronExpression;
    private LocalDateTime lastExecution;
    private String lastStatus= "NEVER_RUN";
}