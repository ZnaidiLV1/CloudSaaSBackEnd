package org.example.resolver;

import org.example.service.VmDiskSpaceService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
public class VmDiskSpaceResolver {

    private final VmDiskSpaceService vmDiskSpaceService;

    public VmDiskSpaceResolver(VmDiskSpaceService vmDiskSpaceService) {
        this.vmDiskSpaceService = vmDiskSpaceService;
    }

    @QueryMapping
    public String listAllWorkspaces() {
        return vmDiskSpaceService.listAllWorkspaces();
    }

    @QueryMapping
    public String getVmDiskFreeSpace(@Argument String vmId) {
        return vmDiskSpaceService.getVmDiskFreeSpace(vmId);
    }
}