package org.example.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.InfrastructureResponse;
import org.example.service.InfrastructureService;
import org.example.service.VmService;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Slf4j
@Controller
@RequiredArgsConstructor
public class InfrastructureResolver {

    private final InfrastructureService infrastructureService;

    @QueryMapping
    public InfrastructureResponse getAllInfrastructure() {
        log.info("GraphQL Query: getAllInfrastructure called");
        return infrastructureService.getAllInfrastructure();
    }
}