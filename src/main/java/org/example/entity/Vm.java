package org.example.entity;

import jakarta.persistence.*;
import lombok.*;
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