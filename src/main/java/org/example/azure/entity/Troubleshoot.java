package org.example.azure.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "troubleshoot")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Troubleshoot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "vm_id")
    private Long vmId;

    @Column(name = "execution_id")
    private String executionId;

    @Column(name = "summary", columnDefinition = "TEXT")
    private String summary;

    @Column(name = "severity")
    private String severity;

    @Column(name = "action")
    private String action;

    @Column(name = "spring_boot_status")
    private String springBootStatus;

    @Column(name = "spring_boot_details", columnDefinition = "TEXT")
    private String springBootDetails;

    @Column(name = "spring_boot_suggestion", columnDefinition = "TEXT")
    private String springBootSuggestion;

    @Column(name = "syslog_status")
    private String syslogStatus;

    @Column(name = "syslog_details", columnDefinition = "TEXT")
    private String syslogDetails;

    @Column(name = "syslog_suggestion", columnDefinition = "TEXT")
    private String syslogSuggestion;

    @Column(name = "pm2_status")
    private String pm2Status;

    @Column(name = "pm2_details", columnDefinition = "TEXT")
    private String pm2Details;

    @Column(name = "pm2_suggestion", columnDefinition = "TEXT")
    private String pm2Suggestion;

    @Column(name = "nginx_status")
    private String nginxStatus;

    @Column(name = "nginx_details", columnDefinition = "TEXT")
    private String nginxDetails;

    @Column(name = "nginx_suggestion", columnDefinition = "TEXT")
    private String nginxSuggestion;

    @Column(name = "postgresql_status")
    private String postgresqlStatus;

    @Column(name = "postgresql_details", columnDefinition = "TEXT")
    private String postgresqlDetails;

    @Column(name = "postgresql_suggestion", columnDefinition = "TEXT")
    private String postgresqlSuggestion;

    @Column(name = "uptime")
    private String uptime;

    @Column(name = "memory", columnDefinition = "TEXT")
    private String memory;

    @Column(name = "disk", columnDefinition = "TEXT")
    private String disk;

    @Column(name = "cpu")
    private String cpu;

    @Column(name = "network", columnDefinition = "TEXT")
    private String network;

    @Column(name = "system_status")
    private String systemStatus;

    @Column(name = "system_details", columnDefinition = "TEXT")
    private String systemDetails;

    @Column(name = "system_suggestion", columnDefinition = "TEXT")
    private String systemSuggestion;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "started_at")
    private LocalDateTime startedAt;

    @Column(name = "stopped_at")
    private LocalDateTime stoppedAt;

    @Column(name = "execution_status")
    private String executionStatus;
}