package org.example.service;

import com.azure.monitor.query.LogsQueryClient;
import com.azure.monitor.query.models.LogsQueryResult;
import com.azure.monitor.query.models.LogsTableRow;
import com.azure.monitor.query.models.QueryTimeInterval;
import com.azure.resourcemanager.AzureResourceManager;
import com.azure.resourcemanager.compute.models.VirtualMachine;
import com.azure.resourcemanager.compute.models.VirtualMachineDataDisk;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class VmDiskSpaceService {

    private static final Logger log = LoggerFactory.getLogger(VmDiskSpaceService.class);

    private final LogsQueryClient logsQueryClient;
    private final AzureResourceManager azureResourceManager;

    @Value("${azure.workspace.ltrms}")
    private String workspaceLtrms;

    @Value("${azure.workspace.pap}")
    private String workspacePap;

    @Value("${azure.workspace.takwinland}")
    private String workspaceTakwinland;

    @Value("${azure.workspace.cip}")
    private String workspaceCip;

    public String getVmDiskFreeSpace(String vmId) {
        log.info("========== GETTING DISK FREE SPACE FOR VM ID: {} ==========", vmId);
        return processVmDiskSpace(vmId, null);
    }

    public String getRootDiskSpace(String vmName) {
        log.info("========== GETTING ROOT DISK SPACE FOR VM NAME: {} ==========", vmName);
        return processVmDiskSpace(null, vmName);
    }

    public String listAllWorkspaces() {
        log.info("========== LISTING ALL LOG ANALYTICS WORKSPACES ==========");
        try {
            azureResourceManager.genericResources()
                    .list()
                    .stream()
                    .filter(r -> r.resourceType().equalsIgnoreCase("workspaces")
                            && r.resourceProviderNamespace().equalsIgnoreCase("Microsoft.OperationalInsights"))
                    .forEach(r -> {
                        log.info("Workspace Name : {}", r.name());
                        log.info("Resource Group : {}", r.resourceGroupName());
                        log.info("Resource ID    : {}", r.id());
                        log.info("Region         : {}", r.regionName());
                        log.info("Properties     : {}", r.properties());
                        log.info("--------------------------------------------");
                    });
        } catch (Exception e) {
            log.error("Failed to list workspaces: {}", e.getMessage());
        }
        log.info("========== DONE ==========");
        return" ok mrigl";
    }

    private String processVmDiskSpace(String vmId, String vmNameDirect) {
        String vmName = vmNameDirect;
        VirtualMachine azureVm = null;

        if (vmName == null && vmId != null) {
            try {
                azureVm = azureResourceManager.virtualMachines().getById(vmId);
                if (azureVm != null) {
                    vmName = azureVm.name();
                }
            } catch (Exception e) {
                log.warn("Could not resolve VM from ID: {}", e.getMessage());
                String[] parts = vmId.split("/");
                vmName = parts[parts.length - 1];
            }
        }

        if (vmName == null) {
            log.error("Failed to resolve VM name");
            return "Check logs - VM not found";
        }

        if (azureVm == null && vmId != null) {
            try {
                azureVm = azureResourceManager.virtualMachines().getById(vmId);
            } catch (Exception e) {
                log.warn("Could not fetch Azure VM details: {}", e.getMessage());
            }
        }

        String workspaceId = resolveWorkspaceIdByVmName(vmName);
        if (workspaceId == null) {
            log.error("No workspace mapped for VM: {}", vmName);
            return "Check logs - workspace not found";
        }

        Map<String, DiskFreeSpace> freeSpaceMap = getFreeSpaceFromLogAnalytics(workspaceId, vmName);

        if (azureVm != null) {
            showCompleteDiskInfo(azureVm, freeSpaceMap);
        } else {
            showDiskInfoFromLogsOnly(vmName, freeSpaceMap);
        }

        log.info("========== DISK SPACE CHECK COMPLETE FOR VM: {} ==========", vmName);
        return "Check logs for disk space details";
    }

    private Map<String, DiskFreeSpace> getFreeSpaceFromLogAnalytics(String workspaceId, String vmName) {
        Map<String, DiskFreeSpace> diskMap = new HashMap<>();

        String query = String.format("""
            InsightsMetrics
            | where TimeGenerated > ago(2h)
            | where Computer == "%s"
            | where Namespace == "LogicalDisk"
            | where Name in ("FreeSpacePercentage", "FreeSpaceMB")
            | extend MountPoint = tostring(todynamic(Tags)["vm.azm.ms/mountId"])
            | project TimeGenerated, MountPoint, Name, Val
            | order by TimeGenerated desc
            """, vmName);

        try {
            LogsQueryResult result = logsQueryClient.queryWorkspace(
                    workspaceId,
                    query,
                    new QueryTimeInterval(Duration.ofHours(2))
            );

            if (result.getTable() != null && !result.getTable().getRows().isEmpty()) {
                for (LogsTableRow row : result.getTable().getRows()) {
                    Optional<com.azure.monitor.query.models.LogsTableCell> mountCell = row.getColumnValue("MountPoint");
                    Optional<com.azure.monitor.query.models.LogsTableCell> nameCell = row.getColumnValue("Name");
                    Optional<com.azure.monitor.query.models.LogsTableCell> valCell = row.getColumnValue("Val");

                    if (mountCell.isPresent() && nameCell.isPresent() && valCell.isPresent()) {
                        String mountPoint = mountCell.get().getValueAsString();
                        String metricName = nameCell.get().getValueAsString();
                        Double metricValue = valCell.get().getValueAsDouble();

                        if (mountPoint == null || mountPoint.isEmpty()) {
                            continue;
                        }

                        DiskFreeSpace disk = diskMap.computeIfAbsent(mountPoint, k -> new DiskFreeSpace());
                        disk.mountPoint = mountPoint;

                        if (metricName.equals("FreeSpacePercentage")) {
                            disk.freePercent = metricValue;
                        } else if (metricName.equals("FreeSpaceMB")) {
                            disk.freeMB = metricValue;
                            disk.freeGB = metricValue / 1024;
                        }

                        diskMap.put(mountPoint, disk);
                    }
                }
            }
        } catch (Exception e) {
            log.error("Failed to query Log Analytics: {}", e.getMessage());
        }

        return diskMap;
    }

    private void showCompleteDiskInfo(VirtualMachine azureVm, Map<String, DiskFreeSpace> freeSpaceMap) {
        String vmName = azureVm.name();

        log.info("==================================================");
        log.info("VM: {}", vmName);
        log.info("==================================================");

        List<VirtualMachineDataDisk> dataDisks = new ArrayList<>(azureVm.dataDisks().values());

        boolean hasDataDisks = dataDisks != null && !dataDisks.isEmpty();

        for (Map.Entry<String, DiskFreeSpace> entry : freeSpaceMap.entrySet()) {
            String mountPoint = entry.getKey();
            DiskFreeSpace disk = entry.getValue();

            boolean isRoot = mountPoint.equals("/");
            boolean isDataDisk = !isRoot && !mountPoint.startsWith("/boot")
                    && !mountPoint.startsWith("/sys") && !mountPoint.startsWith("/proc")
                    && !mountPoint.contains("efi");

            if (isRoot) {
                log.info("🔵 OS DISK (Root):");
                log.info("   Mount Point: {}", mountPoint);
                if (disk.freePercent != null) {
                    log.info("   Free Space: {}%", Math.round(disk.freePercent * 100.0) / 100.0);
                }
                if (disk.freeMB != null) {
                    log.info("   Free Space: {} MB ({} GB)",
                            Math.round(disk.freeMB * 100.0) / 100.0,
                            Math.round(disk.freeGB * 100.0) / 100.0);
                }
                log.info("   Type: OS Disk");
                log.info("");
            }
        }

        if (hasDataDisks) {
            log.info("🟢 LINKED DATA DISKS (Attached to this VM):");

            for (VirtualMachineDataDisk dataDisk : dataDisks) {
                log.info("");
                log.info("   Disk Name: {}", dataDisk.name());
                log.info("   Size: {} GB", dataDisk.size());
                log.info("   LUN: {}", dataDisk.lun());
                log.info("   Caching: {}", dataDisk.cachingType());

                String matchedMount = findMatchingMountPoint(dataDisk.name(), dataDisk.size(), freeSpaceMap);
                if (matchedMount != null && freeSpaceMap.containsKey(matchedMount)) {
                    DiskFreeSpace disk = freeSpaceMap.get(matchedMount);
                    log.info("   Mount Point: {}", matchedMount);
                    if (disk.freePercent != null) {
                        log.info("   Free Space: {}%", Math.round(disk.freePercent * 100.0) / 100.0);
                    }
                    if (disk.freeMB != null) {
                        log.info("   Free Space: {} MB ({} GB)",
                                Math.round(disk.freeMB * 100.0) / 100.0,
                                Math.round(disk.freeGB * 100.0) / 100.0);
                    }
                    log.info("   Status: ✓ LINKED AND ACTIVE");
                } else {
                    log.info("   Mount Point: Not mounted or no data available");
                    log.info("   Status: ⚠️ ATTACHED BUT NOT MOUNTED");
                }
            }
            log.info("");
        } else {
            log.info("🟢 LINKED DATA DISKS:");
            log.info("   No data disks attached to this VM");
            log.info("");
        }

        List<String> orphanMounts = new ArrayList<>();
        for (Map.Entry<String, DiskFreeSpace> entry : freeSpaceMap.entrySet()) {
            String mountPoint = entry.getKey();
            if (!mountPoint.equals("/") && !mountPoint.startsWith("/boot")
                    && !mountPoint.startsWith("/sys") && !mountPoint.startsWith("/proc")
                    && !mountPoint.contains("efi")) {

                boolean found = false;
                if (hasDataDisks) {
                    for (VirtualMachineDataDisk dataDisk : dataDisks) {
                        String matched = findMatchingMountPoint(dataDisk.name(), dataDisk.size(), freeSpaceMap);
                        if (matched != null && matched.equals(mountPoint)) {
                            found = true;
                            break;
                        }
                    }
                }
                if (!found) {
                    orphanMounts.add(mountPoint);
                }
            }
        }

        if (!orphanMounts.isEmpty()) {
            log.info("🟡 ADDITIONAL MOUNTS (Not linked to Azure Data Disks):");
            for (String mount : orphanMounts) {
                DiskFreeSpace disk = freeSpaceMap.get(mount);
                log.info("   Mount Point: {}", mount);
                if (disk.freePercent != null) {
                    log.info("     Free Space: {}%", Math.round(disk.freePercent * 100.0) / 100.0);
                }
                if (disk.freeMB != null) {
                    log.info("     Free Space: {} MB ({} GB)",
                            Math.round(disk.freeMB * 100.0) / 100.0,
                            Math.round(disk.freeGB * 100.0) / 100.0);
                }
            }
            log.info("");
        }

        logHealthAssessment(freeSpaceMap);

        log.info("==================================================");
    }

    private void showDiskInfoFromLogsOnly(String vmName, Map<String, DiskFreeSpace> freeSpaceMap) {
        log.info("==================================================");
        log.info("VM: {} (Azure VM details not available)", vmName);
        log.info("==================================================");

        for (Map.Entry<String, DiskFreeSpace> entry : freeSpaceMap.entrySet()) {
            String mountPoint = entry.getKey();
            DiskFreeSpace disk = entry.getValue();

            boolean isRoot = mountPoint.equals("/");
            boolean isDataDisk = !isRoot && !mountPoint.startsWith("/boot")
                    && !mountPoint.startsWith("/sys") && !mountPoint.startsWith("/proc")
                    && !mountPoint.contains("efi");

            if (isRoot) {
                log.info("🔵 OS DISK (Root):");
                log.info("   Mount Point: {}", mountPoint);
                if (disk.freePercent != null) {
                    log.info("   Free Space: {}%", Math.round(disk.freePercent * 100.0) / 100.0);
                }
                if (disk.freeMB != null) {
                    log.info("   Free Space: {} MB ({} GB)",
                            Math.round(disk.freeMB * 100.0) / 100.0,
                            Math.round(disk.freeGB * 100.0) / 100.0);
                }
                log.info("");
            }
        }

        boolean hasDataMounts = false;
        for (Map.Entry<String, DiskFreeSpace> entry : freeSpaceMap.entrySet()) {
            String mountPoint = entry.getKey();
            if (!mountPoint.equals("/") && !mountPoint.startsWith("/boot")
                    && !mountPoint.startsWith("/sys") && !mountPoint.startsWith("/proc")
                    && !mountPoint.contains("efi")) {
                if (!hasDataMounts) {
                    log.info("🟢 DATA DISKS (From Log Analytics):");
                    hasDataMounts = true;
                }
                DiskFreeSpace disk = entry.getValue();
                log.info("   Mount Point: {}", mountPoint);
                if (disk.freePercent != null) {
                    log.info("     Free Space: {}%", Math.round(disk.freePercent * 100.0) / 100.0);
                }
                if (disk.freeMB != null) {
                    log.info("     Free Space: {} MB ({} GB)",
                            Math.round(disk.freeMB * 100.0) / 100.0,
                            Math.round(disk.freeGB * 100.0) / 100.0);
                }
            }
        }

        if (!hasDataMounts) {
            log.info("🟢 DATA DISKS:");
            log.info("   No data disks found in Log Analytics");
        }

        log.info("");
        logHealthAssessment(freeSpaceMap);

        log.info("==================================================");
    }

    private String findMatchingMountPoint(String diskName, int diskSizeGb, Map<String, DiskFreeSpace> freeSpaceMap) {
        for (Map.Entry<String, DiskFreeSpace> entry : freeSpaceMap.entrySet()) {
            String mountPoint = entry.getKey();
            DiskFreeSpace disk = entry.getValue();

            if (mountPoint.equals("/") || mountPoint.startsWith("/boot")
                    || mountPoint.startsWith("/sys") || mountPoint.startsWith("/proc")
                    || mountPoint.contains("efi")) {
                continue;
            }

            if (disk.freeMB != null && disk.freeGB != null) {
                double estimatedTotalGb = disk.freeGB / ((100 - (disk.freePercent != null ? disk.freePercent : 50)) / 100);
                if (Math.abs(estimatedTotalGb - diskSizeGb) < diskSizeGb * 0.2) {
                    return mountPoint;
                }
            }

            if (diskName.toLowerCase().contains("data") && mountPoint.contains("data")) {
                return mountPoint;
            }
            if (diskName.toLowerCase().contains("log") && mountPoint.contains("log")) {
                return mountPoint;
            }
        }

        for (Map.Entry<String, DiskFreeSpace> entry : freeSpaceMap.entrySet()) {
            String mountPoint = entry.getKey();
            if (!mountPoint.equals("/") && !mountPoint.startsWith("/boot")
                    && !mountPoint.startsWith("/sys") && !mountPoint.startsWith("/proc")
                    && !mountPoint.contains("efi")) {
                return mountPoint;
            }
        }

        return null;
    }

    private void logHealthAssessment(Map<String, DiskFreeSpace> freeSpaceMap) {
        log.info("📊 HEALTH ASSESSMENT:");

        for (Map.Entry<String, DiskFreeSpace> entry : freeSpaceMap.entrySet()) {
            String mountPoint = entry.getKey();
            DiskFreeSpace disk = entry.getValue();

            if (mountPoint.equals("/")) {
                if (disk.freePercent != null) {
                    if (disk.freePercent < 10) {
                        log.error("   ❌ CRITICAL: Root disk less than 10% free!");
                    } else if (disk.freePercent < 20) {
                        log.warn("   ⚠️ WARNING: Root disk less than 20% free!");
                    } else if (disk.freePercent < 30) {
                        log.info("   ℹ️ INFO: Root disk less than 30% free - monitor closely");
                    } else {
                        log.info("   ✅ Healthy: Root disk has sufficient free space");
                    }
                }
            } else if (!mountPoint.startsWith("/boot") && !mountPoint.startsWith("/sys")
                    && !mountPoint.startsWith("/proc") && !mountPoint.contains("efi")) {
                if (disk.freePercent != null && disk.freePercent < 10) {
                    log.warn("   ⚠️ WARNING: Data disk at {} less than 10% free!", mountPoint);
                } else if (disk.freeMB != null && disk.freeMB < 1024) {
                    log.warn("   ⚠️ WARNING: Data disk at {} less than 1GB free!", mountPoint);
                }
            }
        }
    }

    private String resolveWorkspaceIdByVmName(String vmName) {
        if (vmName == null) return null;
        String lower = vmName.toLowerCase();
        if (lower.contains("ltrms")) return workspaceLtrms;
        if (lower.contains("pap")) return workspacePap;
        if (lower.contains("takwin")) return workspaceTakwinland;
        if (lower.contains("cip")) return workspaceCip;
        return workspaceLtrms;
    }

    private String resolveWorkspaceId(String workspaceId) {
        if (workspaceId == null) return null;
        if (workspaceId.equalsIgnoreCase("ltrms")) return workspaceLtrms;
        if (workspaceId.equalsIgnoreCase("pap")) return workspacePap;
        if (workspaceId.equalsIgnoreCase("takwinland")) return workspaceTakwinland;
        if (workspaceId.equalsIgnoreCase("cip")) return workspaceCip;
        if (workspaceId.equalsIgnoreCase(workspaceLtrms)) return workspaceLtrms;
        return null;
    }

    private static class DiskFreeSpace {
        String mountPoint;
        Double freePercent;
        Double freeMB;
        Double freeGB;
    }
}