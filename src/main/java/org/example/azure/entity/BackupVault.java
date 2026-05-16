package org.example.azure.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "backup_vault")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BackupVault {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 100)
    private String vaultName;

    @Column(length = 100)
    private String resourceGroup;

    @Column(length = 50)
    private String location;

    @Column(length = 50)
    private String storageType;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;
}