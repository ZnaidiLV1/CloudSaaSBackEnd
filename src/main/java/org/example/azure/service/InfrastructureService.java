
package org.example.azure.service;

import lombok.RequiredArgsConstructor;
import org.example.azure.dto.InfrastructureResponse;
import org.example.azure.entity.Tag;
import org.example.azure.entity.Vm;
import org.example.azure.repository.TagRepository;
import org.example.azure.repository.VmRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class InfrastructureService {

    private static final Logger log = LoggerFactory.getLogger(VmService.class);

    private final VmRepository vmRepository;
    private final TagRepository tagRepository;

    @Transactional(readOnly = true)
    public InfrastructureResponse getAllInfrastructure() {
        log.info("Fetching all infrastructure data");

        
        List<Vm> vms = vmRepository.findAllVmsWithoutTags();

        
        List<InfrastructureResponse.VmDto> vmDtos = vms.stream()
                .map(this::convertToVmDto)
                .collect(Collectors.toList());

        
        List<Tag> tags = tagRepository.findAll();

        
        List<InfrastructureResponse.TagDto> tagDtos = tags.stream()
                .map(this::convertToTagDto)
                .collect(Collectors.toList());

        
        List<InfrastructureResponse.VmTagRelationDto> vmTagRelations = buildVmTagRelations(vms);

        log.info("Returning {} VMs, {} Tags, {} Relations",
                vmDtos.size(), tagDtos.size(), vmTagRelations.size());

        return InfrastructureResponse.builder()
                .vms(vmDtos)
                .tags(tagDtos)
                .vmTags(vmTagRelations)
                .build();
    }

    private InfrastructureResponse.VmDto convertToVmDto(Vm vm) {
        return InfrastructureResponse.VmDto.builder()
                .id(vm.getId())
                .name(vm.getName())
                .status(vm.getStatus())
                .vmType(vm.getVmType())
                .publicIpAddress(vm.getPublicIpAddress())
                .billingType(vm.getBillingType() != null ? vm.getBillingType().name() : "PAYG")
                .region(vm.getRegion())
                .resourceGroup(vm.getResourceGroup())
                .build();
    }

    private InfrastructureResponse.TagDto convertToTagDto(Tag tag) {
        return InfrastructureResponse.TagDto.builder()
                .id(tag.getId())
                .key(tag.getKey())
                .value(tag.getValue())
                .build();
    }

    private List<InfrastructureResponse.VmTagRelationDto> buildVmTagRelations(List<Vm> vms) {
        List<InfrastructureResponse.VmTagRelationDto> relations = new ArrayList<>();

        for (Vm vm : vms) {
            
            List<Tag> vmTags = vm.getTags();
            if (vmTags != null) {
                for (Tag tag : vmTags) {
                    relations.add(InfrastructureResponse.VmTagRelationDto.builder()
                            .vmId(vm.getId())
                            .tagId(tag.getId())
                            .build());
                }
            }
        }

        return relations;
    }
}