package org.example.service;

import com.azure.monitor.query.LogsQueryClient;
import com.azure.monitor.query.models.LogsQueryResult;
import com.azure.monitor.query.models.QueryTimeInterval;
import com.azure.resourcemanager.AzureResourceManager;
import com.azure.resourcemanager.compute.models.VirtualMachine;
import com.azure.resourcemanager.network.models.NetworkInterface;
import com.azure.resourcemanager.network.models.NicIpConfiguration;
import com.azure.resourcemanager.network.models.PublicIpAddress;
import com.azure.resourcemanager.resources.models.GenericResource;
import lombok.RequiredArgsConstructor;
import org.example.dto.VMDTOs.VmDiskInfoDto;
import org.example.entity.Tag;
import org.example.entity.Vm;
import org.example.entity.Workspace;
import org.example.enums.BillingType;
import org.example.repository.TagRepository;
import org.example.repository.VmRepository;
import org.example.repository.WorkspaceRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VmService {

    private static final Logger log = LoggerFactory.getLogger(VmService.class);

    private final VmRepository vmRepository;
    private final WorkspaceRepository workspaceRepository;
    private final AzureResourceManager azure;
    private final TagRepository tagRepository;
    private final LogsQueryClient logsQueryClient;

    @Transactional
    public void syncAzureInfrastructure() {
        log.info("Starting Azure infrastructure sync...");

        discoverAndSaveWorkspaces();

        List<Workspace> allWorkspaces = workspaceRepository.findAll();
        log.info("Found {} workspaces in database", allWorkspaces.size());

        for (VirtualMachine azureVm : azure.virtualMachines().list()) {
            try {
                log.info("Processing VM: {} in Resource Group: {}", azureVm.name(), azureVm.resourceGroupName());

                Vm vm = vmRepository.findByAzureVmId(azureVm.id())
                        .orElse(Vm.builder()
                                .azureVmId(azureVm.id())
                                .build()
                        );

                vm.setName(azureVm.name());
                vm.setResourceGroup(azureVm.resourceGroupName());
                vm.setRegion(azureVm.regionName());

                String powerState = azureVm.powerState() != null ? azureVm.powerState().toString() : "UNKNOWN";
                vm.setStatus(powerState);

                String vmType = azureVm.size() != null ? azureVm.size().toString() : "UNKNOWN";

                if (vmType.startsWith("Standard_")) {
                    vmType = vmType.substring(9);
                }

                vmType = vmType.replace("_", " ");
                vm.setVmType(vmType);

                String publicIp = null;
                try {
                    NetworkInterface nic = azureVm.getPrimaryNetworkInterface();
                    if (nic != null) {
                        List<NicIpConfiguration> ipConfigs = new ArrayList<>(nic.ipConfigurations().values());
                        if (!ipConfigs.isEmpty()) {
                            NicIpConfiguration primaryIpConfig = ipConfigs.get(0);
                            PublicIpAddress publicIpAddress = primaryIpConfig.getPublicIpAddress();
                            if (publicIpAddress != null) {
                                publicIp = publicIpAddress.ipAddress();
                            }
                        }
                    }
                } catch (Exception e) {
                    log.warn("Could not retrieve Public IP for VM {}: {}", azureVm.name(), e.getMessage());
                }
                vm.setPublicIpAddress(publicIp);
                vm.setDomainName(null);

                Workspace linkedWorkspace = findWorkspaceForVmDynamic(azureVm.name(), allWorkspaces);
                if (linkedWorkspace != null) {
                    vm.setWorkspace(linkedWorkspace);
                    log.info("Linked VM {} to workspace: {} ({})",
                            vm.getName(), linkedWorkspace.getName(), linkedWorkspace.getWorkspaceId());
                } else {
                    log.warn("No workspace found for VM: {}", vm.getName());
                    vm.setWorkspace(null);
                }

                if (vm.getTags() == null) {
                    vm.setTags(new ArrayList<>());
                }
                vm.getTags().clear();

                Map<String, String> azureTags = azureVm.tags();
                if (azureTags != null && !azureTags.isEmpty()) {
                    for (Map.Entry<String, String> entry : azureTags.entrySet()) {
                        Tag tag = tagRepository.findByKeyAndValue(entry.getKey(), entry.getValue())
                                .orElseGet(() -> {
                                    log.info("Tag not found in DB, creating: {} = {}", entry.getKey(), entry.getValue());
                                    return tagRepository.save(
                                            Tag.builder()
                                                    .key(entry.getKey())
                                                    .value(entry.getValue())
                                                    .build()
                                    );
                                });
                        vm.getTags().add(tag);
                    }
                }

                vmRepository.save(vm);

                log.info("VM saved: {} | Status: {} | Workspace: {}",
                        vm.getName(), powerState,
                        linkedWorkspace != null ? linkedWorkspace.getName() : "None");

            } catch (Exception e) {
                log.error("Error processing VM {}: {}", azureVm.name(), e.getMessage(), e);
            }
        }

        log.info("Azure infrastructure sync completed.");
    }

    private void discoverAndSaveWorkspaces() {
        log.info("Discovering Log Analytics workspaces...");

        try {
            azure.genericResources()
                    .list()
                    .stream()
                    .filter(r -> r.resourceType().equalsIgnoreCase("workspaces")
                            && r.resourceProviderNamespace().equalsIgnoreCase("Microsoft.OperationalInsights"))
                    .forEach(r -> {
                        try {
                            GenericResource full = azure.genericResources().getById(r.id());
                            Object props = full.properties();

                            String customerId = null;
                            String sku = null;
                            Integer retentionDays = null;

                            if (props instanceof java.util.Map<?, ?> map) {
                                customerId = (String) map.get("customerId");
                                Object skuObj = map.get("sku");
                                if (skuObj instanceof java.util.Map<?, ?> skuMap) {
                                    sku = (String) skuMap.get("name");
                                }
                                retentionDays = (Integer) map.get("retentionInDays");
                            }

                            if (customerId != null) {
                                Workspace workspace = workspaceRepository.findByWorkspaceId(customerId)
                                        .orElse(Workspace.builder()
                                                .workspaceId(customerId)
                                                .build());

                                workspace.setName(r.name());
                                workspace.setResourceGroup(r.resourceGroupName());
                                workspace.setRegion(r.regionName());
                                workspace.setSku(sku);
                                workspace.setRetentionDays(retentionDays);
                                workspace.setLastSyncedAt(LocalDateTime.now());

                                workspaceRepository.save(workspace);
                                log.info("Saved/Updated workspace: {} ({})", workspace.getName(), workspace.getWorkspaceId());
                            }
                        } catch (Exception e) {
                            log.error("Failed to process workspace {}: {}", r.name(), e.getMessage());
                        }
                    });
        } catch (Exception e) {
            log.error("Failed to discover workspaces: {}", e.getMessage());
        }
    }

    private Workspace findWorkspaceForVmDynamic(String vmName, List<Workspace> workspaces) {
        String lowerVmName = vmName.toLowerCase();

        String vmPrefix = extractVmPrefix(lowerVmName);
        if (vmPrefix == null) {
            log.warn("Could not extract prefix from VM name: {}", vmName);
            return null;
        }

        for (Workspace workspace : workspaces) {
            String lowerWsName = workspace.getName().toLowerCase();

            if (lowerWsName.contains(vmPrefix)) {
                log.info("Matched VM {} (prefix: {}) to workspace: {}", vmName, vmPrefix, workspace.getName());
                return workspace;
            }
        }

        log.warn("No workspace found for VM {} with prefix: {}", vmName, vmPrefix);
        return null;
    }

    private String extractVmPrefix(String vmName) {
        if (vmName.contains("-")) {
            return vmName.split("-")[0];
        }

        String[] commonPrefixes = {"ltrms", "pap", "takwin", "cip"};
        for (String prefix : commonPrefixes) {
            if (vmName.startsWith(prefix)) {
                return prefix;
            }
        }

        return null;
    }

    public List<Vm> getAllVms() {
        return vmRepository.findAll();
    }

    public List<Vm> getVmsByProduct(String product) {
        return vmRepository.findByProduct(product);
    }

    public List<String> getAllProducts() {
        return vmRepository.findAllProducts();
    }

    public Vm getByAzureVmId(String azureVmId) {
        return vmRepository.findByAzureVmId(azureVmId)
                .orElseThrow(() -> new RuntimeException("VM not found: " + azureVmId));
    }

    public List<Vm> getVmsByType(String vmType) {
        return vmRepository.findByVmType(vmType);
    }

    public List<VmBillingDto> getAllVmBillingTypes() {
        return vmRepository.findAll().stream()
                .map(vm -> new VmBillingDto(
                        vm.getId(),
                        vm.getName(),
                        vm.getVmType(),
                        vm.getBillingType() != null ? vm.getBillingType().name() : "PAYG"
                ))
                .collect(Collectors.toList());
    }

    public List<VmPublicIpDto> getAllVmsWithPublicIp() {
        return vmRepository.findAll().stream()
                .map(vm -> new VmPublicIpDto(
                        vm.getId(),
                        vm.getName(),
                        vm.getPublicIpAddress(),
                        vm.getDomainName(),
                        vm.getBillingType() != null ? vm.getBillingType().toString() : "PAYG"
                ))
                .collect(Collectors.toList());
    }

    @Transactional
    public String updateDomainName(Long vmId, String domainName) {
        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        vm.setDomainName(domainName);
        vmRepository.save(vm);

        log.info("Domain name updated for VM ID: {} with domain: {}", vmId, domainName);
        return "Domain name updated successfully for VM: " + vm.getName();
    }

    @Transactional
    public void updateBillingType(Long vmId, String billingType) {
        BillingType enumValue = BillingType.valueOf(billingType);
        vmRepository.updateBillingTypeEnum(vmId, enumValue);
    }

    public static class VmBillingDto {
        public Long vmId;
        public String vmName;
        public String vmType;
        public String billingType;

        public VmBillingDto(Long vmId, String vmName, String vmType, String billingType) {
            this.vmId = vmId;
            this.vmName = vmName;
            this.vmType = vmType;
            this.billingType = billingType;
        }
    }

    public VmDiskInfoDto getVmDiskInfoById(Long vmId) {
        Vm vm = vmRepository.findById(vmId).orElse(null);

        if (vm == null) {
            return VmDiskInfoDto.builder()
                    .vmName("VM not found")
                    .workspaceName("VM not found")
                    .build();
        }

        String workspaceName = vm.getWorkspace() != null ? vm.getWorkspace().getName() : "No workspace linked";
        String vmName = vm.getName() != null ? vm.getName() : "VM " + vmId;

        Double freePercent = vm.getDiskFreePercent() != null
                ? Math.round(vm.getDiskFreePercent() * 100.0) / 100.0 : null;
        Double freeMB = vm.getDiskFreeMB() != null
                ? Math.round(vm.getDiskFreeMB() * 100.0) / 100.0 : null;
        Double freeGB = vm.getDiskFreeGB() != null
                ? Math.round(vm.getDiskFreeGB() * 100.0) / 100.0 : null;

        return VmDiskInfoDto.builder()
                .vmName(vmName)
                .workspaceName(workspaceName)
                .diskFreePercent(freePercent)
                .diskFreeMB(freeMB)
                .diskFreeGB(freeGB)
                .diskLastUpdated(vm.getDiskLastUpdated())
                .build();
    }

    public static class VmPublicIpDto {
        public Long id;
        public String vmName;
        public String ipAddress;
        public String domainName;
        public String billingType;

        public VmPublicIpDto(Long id, String vmName, String ipAddress, String domainName, String billingType) {
            this.id = id;
            this.vmName = vmName;
            this.ipAddress = ipAddress;
            this.domainName = domainName;
            this.billingType = billingType;
        }
    }
}