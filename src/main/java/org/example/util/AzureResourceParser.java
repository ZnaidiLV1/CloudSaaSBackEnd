package org.example.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
@Slf4j
public class AzureResourceParser {

    // Patterns for different Azure resource types
    private static final Pattern VM_PATTERN = Pattern.compile("/virtualMachines/([^/]+)");
    private static final Pattern DISK_PATTERN = Pattern.compile("/disks/([^/]+)");
    private static final Pattern SNAPSHOT_PATTERN = Pattern.compile("/snapshots/([^/]+)");
    private static final Pattern NIC_PATTERN = Pattern.compile("/networkInterfaces/([^/]+)");
    private static final Pattern PUBLIC_IP_PATTERN = Pattern.compile("/publicIPAddresses/([^/]+)");
    private static final Pattern BACKUP_PATTERN = Pattern.compile("/backupVaults/([^/]+)");
    private static final Pattern RECOVERY_SERVICES_PATTERN = Pattern.compile("/recoveryServicesVaults/([^/]+)");

    // Resource types that ALWAYS belong to a VM
    private static final Set<String> VM_ATTACHED_RESOURCES = Set.of(
            "Microsoft.Compute/disks",
            "Microsoft.Compute/snapshots",
            "Microsoft.Network/networkInterfaces",
            "Microsoft.Compute/virtualMachines/extensions",
            "Microsoft.RecoveryServices/backupProtectedItems"
    );

    // Shared resources (never belong to a single VM)
    private static final Set<String> SHARED_RESOURCES = Set.of(
            "Microsoft.Storage/storageAccounts",
            "Microsoft.Network/publicIPAddresses",
            "Microsoft.OperationalInsights/workspaces",
            "Microsoft.Network/networkSecurityGroups",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.Network/loadBalancers",
            "Microsoft.ContainerRegistry/registries",
            "Microsoft.KeyVault/vaults"
    );

    /**
     * Parse resource ID and extract VM name if this resource belongs to a VM
     */
    public Optional<String> extractVmName(String resourceId) {
        if (resourceId == null || resourceId.isEmpty()) {
            return Optional.empty();
        }

        // Method 1: Direct VM resource
        Matcher vmMatcher = VM_PATTERN.matcher(resourceId);
        if (vmMatcher.find()) {
            return Optional.of(vmMatcher.group(1));
        }

        // Method 2: Disk naming convention (often contains VM name)
        Matcher diskMatcher = DISK_PATTERN.matcher(resourceId);
        if (diskMatcher.find()) {
            String diskName = diskMatcher.group(1);
            String vmName = extractVmFromDiskName(diskName);
            if (vmName != null) {
                return Optional.of(vmName);
            }
        }

        // Method 3: Snapshot naming convention
        Matcher snapshotMatcher = SNAPSHOT_PATTERN.matcher(resourceId);
        if (snapshotMatcher.find()) {
            String snapshotName = snapshotMatcher.group(1);
            String vmName = extractVmFromSnapshotName(snapshotName);
            if (vmName != null) {
                return Optional.of(vmName);
            }
        }

        return Optional.empty();
    }

    /**
     * Determine if a resource is shared or belongs to a VM
     */
    public boolean isSharedResource(String resourceId, String serviceName) {
        if (resourceId == null || resourceId.isEmpty()) {
            return true;
        }

        // Check if explicitly shared
        for (String sharedType : SHARED_RESOURCES) {
            if (resourceId.contains(sharedType)) {
                return true;
            }
        }

        // Check if it's a VM (not shared)
        if (resourceId.contains("Microsoft.Compute/virtualMachines")) {
            return false;
        }

        // Check if it's attached to VM
        for (String attachedType : VM_ATTACHED_RESOURCES) {
            if (resourceId.contains(attachedType)) {
                return false;
            }
        }

        // Default: assume shared if we can't determine
        return true;
    }

    /**
     * Get resource category for better grouping
     */
    public ResourceCategory getResourceCategory(String resourceId) {
        if (resourceId == null) return ResourceCategory.SHARED;

        if (resourceId.contains("/virtualMachines/")) return ResourceCategory.VM;
        if (resourceId.contains("/disks/")) return ResourceCategory.DISK;
        if (resourceId.contains("/snapshots/")) return ResourceCategory.SNAPSHOT;
        if (resourceId.contains("/networkInterfaces/")) return ResourceCategory.NETWORK;
        if (resourceId.contains("/publicIPAddresses/")) return ResourceCategory.PUBLIC_IP;
        if (resourceId.contains("/storageAccounts/")) return ResourceCategory.STORAGE;
        if (resourceId.contains("/workspaces/")) return ResourceCategory.LOG_ANALYTICS;
        if (resourceId.contains("/backupVaults/")) return ResourceCategory.BACKUP;

        return ResourceCategory.OTHER;
    }

    private String extractVmFromDiskName(String diskName) {
        // Common patterns: "vmname_osdisk_xxx", "vmname_datadisk_xxx"
        String[] patterns = {"_osdisk_", "_datadisk_", "_disk_"};
        for (String pattern : patterns) {
            if (diskName.contains(pattern)) {
                return diskName.substring(0, diskName.indexOf(pattern));
            }
        }
        return null;
    }

    private String extractVmFromSnapshotName(String snapshotName) {
        // Patterns: "vmname_snapshot_date", "azurebackup_vmuuid_date"
        if (snapshotName.contains("azurebackup_")) {
            // Azure backup snapshots contain VM UUID - need separate mapping
            return null; // Will need lookup table for these
        }

        String[] patterns = {"_snapshot_", "_backup_"};
        for (String pattern : patterns) {
            if (snapshotName.contains(pattern)) {
                return snapshotName.substring(0, snapshotName.indexOf(pattern));
            }
        }
        return null;
    }

    public enum ResourceCategory {
        VM, DISK, SNAPSHOT, NETWORK, PUBLIC_IP, STORAGE, LOG_ANALYTICS, BACKUP, SHARED, OTHER
    }
}