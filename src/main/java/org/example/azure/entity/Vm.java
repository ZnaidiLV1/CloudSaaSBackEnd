package org.example.azure.entity;

import jakarta.persistence.*;
import lombok.*;
import org.example.azure.enums.BillingType;

import java.time.LocalDateTime;
import java.util.*;

@Entity
@Table(name = "vms")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vm {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String azureVmId;

    @Column(nullable = false)
    private String name;

    private String resourceGroup;
    private String region;
    private String status;

    @Column(name = "vm_type")
    private String vmType;

    @Enumerated(EnumType.STRING)
    @Column(name = "billing_type")
    private BillingType billingType;

    @Column(name = "public_ip_address")
    private String publicIpAddress;

    @Column(name = "domain_name")
    private String domainName;

    @ManyToOne
    @JoinColumn(name = "workspace_id")
    private Workspace workspace;

    @Column(name = "disk_free_percent")
    private Double diskFreePercent;

    @Column(name = "disk_free_mb")
    private Double diskFreeMB;

    @Column(name = "disk_free_gb")
    private Double diskFreeGB;

    @Column(name = "disk_last_updated")
    private LocalDateTime diskLastUpdated;

    @Builder.Default
    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
            name = "vm_tag",
            joinColumns = @JoinColumn(name = "vm_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id")
    )
    private List<Tag> tags = new ArrayList<>();

    @OneToMany(mappedBy = "vm", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AzureAlert> alerts = new ArrayList<>();

    @OneToMany(mappedBy = "vm", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<PerformanceMetric> metrics = new ArrayList<>();

    @OneToMany(mappedBy = "vm", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CostRecord> costRecords = new ArrayList<>();
}