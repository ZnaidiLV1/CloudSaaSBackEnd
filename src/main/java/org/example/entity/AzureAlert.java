package org.example.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "azure_alerts")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AzureAlert {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vm_id", nullable = false)
    private Vm vm;

    @Column(unique = true)
    private String azureAlertId;

    private String alertName;
    private String severity;
    private String description;
    private LocalDateTime occurredAt;
}