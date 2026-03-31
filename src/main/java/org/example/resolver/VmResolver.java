package org.example.resolver;

import lombok.RequiredArgsConstructor;
import org.example.service.VmService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Controller;

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
}