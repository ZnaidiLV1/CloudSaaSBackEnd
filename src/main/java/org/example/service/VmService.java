package org.example.service;

import com.azure.resourcemanager.AzureResourceManager;
import com.azure.resourcemanager.compute.models.VirtualMachine;
import lombok.RequiredArgsConstructor;
import org.example.entity.Tag;
import org.example.entity.Vm;
import org.example.enums.BillingType;
import org.example.repository.TagRepository;
import org.example.repository.VmRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VmService {

    private static final Logger log = LoggerFactory.getLogger(VmService.class);

    private final VmRepository vmRepository;
    private final AzureResourceManager azure;
    private final TagRepository tagRepository;

    @Transactional
    public void syncAzureInfrastructure() {
        log.info("Starting Azure infrastructure sync...");

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
                vm.setStatus(azureVm.powerState() != null
                        ? azureVm.powerState().toString()
                        : "UNKNOWN"
                );

                String vmType = azureVm.size() != null ? azureVm.size().toString() : "UNKNOWN";

                if (vmType.startsWith("Standard_")) {
                    vmType = vmType.substring(9);
                }

                vmType = vmType.replace("_", " ");

                vm.setVmType(vmType);

                if (vm.getTags() == null) {
                    vm.setTags(new ArrayList<>());
                }
                vm.getTags().clear();

                Map<String, String> azureTags = azureVm.tags();
                if (azureTags != null && !azureTags.isEmpty()) {
                    for (Map.Entry<String, String> entry : azureTags.entrySet()) {
                        log.info("Checking tag: {} = {}", entry.getKey(), entry.getValue());

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
                } else {
                    log.warn("No tags found for VM: {}", azureVm.name());
                }

                vmRepository.save(vm);
                log.info("VM saved successfully: {} with type: {}", vm.getName(), vm.getVmType());

            } catch (Exception e) {
                log.error("Error processing VM {}: {}", azureVm.name(), e.getMessage(), e);
            }
        }

        log.info("Azure infrastructure sync completed.");
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
}