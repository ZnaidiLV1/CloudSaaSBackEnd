package org.example.azure.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "workspaces")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Workspace {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String workspaceId;

    private String name;

    private String resourceGroup;

    private String region;

    private String sku;

    private Integer retentionDays;

    private LocalDateTime lastSyncedAt;
}