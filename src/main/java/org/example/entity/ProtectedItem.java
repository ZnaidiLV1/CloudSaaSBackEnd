package org.example.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "protected_item")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProtectedItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vault_id", nullable = false)
    private BackupVault backupVault;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vm_id")
    private Vm vm;

    @Column(unique = true, nullable = false, length = 255)
    private String backupInstanceId;

    @Column(length = 255)
    private String dataSourceName;

    @Column(length = 100)
    private String dataSourceType;

    @Column(length = 100)
    private String protectionStatus;

    @Builder.Default
    private Boolean isActive = true;

    private LocalDateTime firstDetectedAt;
    private LocalDateTime lastSeenAt;
    private LocalDateTime removedAt;
}