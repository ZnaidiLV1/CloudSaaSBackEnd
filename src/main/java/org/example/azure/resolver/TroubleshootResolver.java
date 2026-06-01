package org.example.azure.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.azure.dto.troubleshootDTOs.TroubleshootResponseDto;
import org.example.azure.service.TroubleshootService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import java.time.LocalDate;
import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class TroubleshootResolver {

    private final TroubleshootService troubleshootService;

    @MutationMapping
    public String saveTroubleshootData() {
        log.info("Manual trigger: Saving troubleshoot data from n8n");
        return troubleshootService.fetchAndSaveLatestHealth();
    }

    @MutationMapping
    public String saveBulkTroubleshootData(@Argument Integer limit) {
        log.info("Manual trigger: Saving bulk troubleshoot data from n8n with limit: {}", limit);
        int fetchLimit = (limit == null || limit > 250) ? 250 : limit;
        return troubleshootService.fetchAndSaveBulkHealth(fetchLimit);
    }

    @QueryMapping
    public List<TroubleshootResponseDto> getTroubleshootByDateAndVmId(@Argument String date, @Argument Long vmId) {
        log.info("Query: Getting troubleshoot data for date {} and vmId {}", date, vmId);
        LocalDate parsedDate = LocalDate.parse(date);
        return troubleshootService.getTroubleshootByDateAndVmId(parsedDate, vmId);
    }
}