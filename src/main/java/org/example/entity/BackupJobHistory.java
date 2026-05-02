package org.example.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "backup_job_history")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BackupJobHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "protected_item_id", nullable = false)
    private ProtectedItem protectedItem;

    @Column(unique = true, nullable = false, length = 255)
    private String jobId;

    @Column(length = 50)
    private String status;

    private LocalDateTime startTime;

    @Column(length = 100)
    private String duration;

    private LocalDateTime syncedAt;
}