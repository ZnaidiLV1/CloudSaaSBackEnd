package org.example.resolver;

import lombok.RequiredArgsConstructor;
import org.example.service.VmService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class VmResolver {

    private static final Logger log = LoggerFactory.getLogger(VmResolver.class);

    private final VmService vmService;

    @MutationMapping
    public String syncAzureInfrastructure() {
        log.info("GraphQL mutation called: syncAzureInfrastructure");
        vmService.syncAzureInfrastructure();
        log.info("GraphQL mutation completed");
        return "Azure sync completed";
    }

    @QueryMapping
    public List<VmService.VmBillingDto> getAllVmBillingTypes() {
        return vmService.getAllVmBillingTypes();
    }

    @QueryMapping
    public List<VmService.VmPublicIpDto> getAllVmsWithPublicIp() {
        return vmService.getAllVmsWithPublicIp();
    }

    @MutationMapping
    public String updateVmDomainName(@Argument Long vmId, @Argument String domainName) {
        return vmService.updateDomainName(vmId, domainName);
    }

    @MutationMapping
    public Boolean updateVmBillingType(@Argument Long vmId, @Argument String billingType) {
        vmService.updateBillingType(vmId, billingType);
        return true;
    }


}