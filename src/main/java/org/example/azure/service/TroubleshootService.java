package org.example.azure.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.azure.dto.troubleshootDTOs.TroubleshootDto;
import org.example.azure.dto.troubleshootDTOs.TroubleshootResponseDto;
import org.example.azure.entity.Troubleshoot;
import org.example.azure.repository.TroubleshootRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class TroubleshootService {

    @Value("${n8n.api.key}")
    private String n8nApiKey;

    @Value("${n8n.api.url}")
    private String n8nApiUrl;

    @Value("${n8n.workflow.id}")
    private String workflowId;

    private final TroubleshootRepository troubleshootRepository;
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Transactional
    public String fetchAndSaveLatestHealth() {
        try {
            String url = n8nApiUrl + "/api/v1/executions?workflowId=" + workflowId + "&limit=1&includeData=true";

            HttpHeaders headers = new HttpHeaders();
            headers.set("X-N8N-API-KEY", n8nApiKey);

            HttpEntity<String> httpEntity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, httpEntity, String.class);

            String healthJson = extractHealthData(response.getBody());

            if (healthJson == null) {
                return "Failed to extract health data";
            }

            TroubleshootDto dto = objectMapper.readValue(healthJson, TroubleshootDto.class);

            String executionId = extractExecutionId(response.getBody());
            LocalDateTime startedAt = extractStartedAt(response.getBody());
            LocalDateTime stoppedAt = extractStoppedAt(response.getBody());
            String executionStatus = extractExecutionStatus(response.getBody());

            dto.setExecutionId(executionId);
            dto.setStartedAt(startedAt);
            dto.setStoppedAt(stoppedAt);
            dto.setExecutionStatus(executionStatus);

            Troubleshoot troubleshootEntity = mapToEntity(dto);

            troubleshootRepository.save(troubleshootEntity);

            log.info("Troubleshoot data saved for VM 4 at {}", LocalDateTime.now());

            return "Saved successfully";

        } catch (Exception e) {
            log.error("Failed to fetch and save troubleshoot data: {}", e.getMessage(), e);
            return "Failed to save: " + e.getMessage();
        }
    }

    @Transactional
    public String fetchAndSaveBulkHealth(int limit) {
        try {
            log.info("Starting bulk fetch with limit: {}", limit);

            String url = n8nApiUrl + "/api/v1/executions?workflowId=" + workflowId + "&limit=" + limit;
            log.info("Fetching executions from URL: {}", url);

            HttpHeaders headers = new HttpHeaders();
            headers.set("X-N8N-API-KEY", n8nApiKey);

            HttpEntity<String> httpEntity = new HttpEntity<>(headers);

            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, httpEntity, String.class);
            log.info("Received response with status code: {}", response.getStatusCode());

            JsonNode root = objectMapper.readTree(response.getBody());
            JsonNode executions = root.path("data");

            log.info("Total executions found in response: {}", executions.size());

            int totalFound = executions.size();
            int newSaved = 0;
            int skipped = 0;
            int failed = 0;

            for (JsonNode execution : executions) {
                String executionId = execution.path("id").asText();
                String executionStatus = execution.path("status").asText();
                log.info("Processing execution ID: {}, status: {}", executionId, executionStatus);

                boolean exists = troubleshootRepository.existsByExecutionId(executionId);
                log.info("Execution {} exists in database: {}", executionId, exists);

                if (exists) {
                    log.info("Skipping execution {} - already exists", executionId);
                    skipped++;
                    continue;
                }

                String executionUrl = n8nApiUrl + "/api/v1/executions/" + executionId + "?includeData=true";
                log.info("Fetching execution data from: {}", executionUrl);

                ResponseEntity<String> executionResponse = restTemplate.exchange(executionUrl, HttpMethod.GET, httpEntity, String.class);
                log.info("Execution data response status: {}", executionResponse.getStatusCode());

                String healthJson = extractHealthData(executionResponse.getBody());

                if (healthJson == null) {
                    log.warn("Health JSON is null for execution {}, skipping", executionId);
                    failed++;
                    continue;
                }

                log.info("Health JSON for execution {} length: {}", executionId, healthJson.length());
                log.debug("Health JSON preview: {}", healthJson.substring(0, Math.min(200, healthJson.length())));

                try {
                    TroubleshootDto dto = objectMapper.readValue(healthJson, TroubleshootDto.class);
                    log.info("Successfully parsed DTO for execution {}", executionId);

                    LocalDateTime startedAt = parseDateTime(execution.path("startedAt").asText());
                    LocalDateTime stoppedAt = parseDateTime(execution.path("stoppedAt").asText());

                    log.info("Execution {} - startedAt: {}, stoppedAt: {}", executionId, startedAt, stoppedAt);

                    dto.setExecutionId(executionId);
                    dto.setStartedAt(startedAt);
                    dto.setStoppedAt(stoppedAt);
                    dto.setExecutionStatus(executionStatus);

                    Troubleshoot troubleshootEntity = mapToEntity(dto);
                    troubleshootRepository.save(troubleshootEntity);
                    newSaved++;
                    log.info("Successfully saved execution {}", executionId);

                } catch (Exception e) {
                    log.error("Failed to parse or save execution {}: {}", executionId, e.getMessage(), e);
                    failed++;
                }
            }

            log.info("Bulk save completed: {} new saved, {} skipped (duplicates), {} failed out of {} total",
                    newSaved, skipped, failed, totalFound);
            return String.format("Saved %d new records out of %d total (skipped %d duplicates, failed %d)",
                    newSaved, totalFound, skipped, failed);

        } catch (Exception e) {
            log.error("Failed to fetch and save bulk troubleshoot data: {}", e.getMessage(), e);
            return "Failed to save bulk data: " + e.getMessage();
        }
    }

    public List<TroubleshootResponseDto> getTroubleshootByDateAndVmId(LocalDate date, Long vmId) {
        try {
            LocalDateTime startOfDay = date.atStartOfDay();
            LocalDateTime endOfDay = date.atTime(LocalTime.MAX);

            List<Troubleshoot> troubleshootList = troubleshootRepository.findByStoppedAtBetween(startOfDay, endOfDay);

            List<TroubleshootResponseDto> result = new ArrayList<>();

            for (Troubleshoot entity : troubleshootList) {
                if (vmId != null && !entity.getVmId().equals(vmId)) {
                    continue;
                }

                TroubleshootResponseDto dto = TroubleshootResponseDto.builder()
                        .id(entity.getId())
                        .vmId(entity.getVmId())
                        .summary(entity.getSummary())
                        .severity(entity.getSeverity())
                        .action(entity.getAction())
                        .createdAt(entity.getCreatedAt())
                        .stoppedAt(entity.getStoppedAt())
                        .components(TroubleshootResponseDto.ComponentsDto.builder()
                                .spring_boot(TroubleshootResponseDto.ComponentDetailDto.builder()
                                        .status(entity.getSpringBootStatus())
                                        .details(entity.getSpringBootDetails())
                                        .suggestion(entity.getSpringBootSuggestion())
                                        .build())
                                .syslog(TroubleshootResponseDto.ComponentDetailDto.builder()
                                        .status(entity.getSyslogStatus())
                                        .details(entity.getSyslogDetails())
                                        .suggestion(entity.getSyslogSuggestion())
                                        .build())
                                .pm2(TroubleshootResponseDto.ComponentDetailDto.builder()
                                        .status(entity.getPm2Status())
                                        .details(entity.getPm2Details())
                                        .suggestion(entity.getPm2Suggestion())
                                        .build())
                                .nginx(TroubleshootResponseDto.ComponentDetailDto.builder()
                                        .status(entity.getNginxStatus())
                                        .details(entity.getNginxDetails())
                                        .suggestion(entity.getNginxSuggestion())
                                        .build())
                                .postgresql(TroubleshootResponseDto.ComponentDetailDto.builder()
                                        .status(entity.getPostgresqlStatus())
                                        .details(entity.getPostgresqlDetails())
                                        .suggestion(entity.getPostgresqlSuggestion())
                                        .build())
                                .system(TroubleshootResponseDto.SystemDetailDto.builder()
                                        .uptime(entity.getUptime())
                                        .memory(entity.getMemory())
                                        .disk(entity.getDisk())
                                        .cpu(entity.getCpu())
                                        .network(entity.getNetwork())
                                        .status(entity.getSystemStatus())
                                        .details(entity.getSystemDetails())
                                        .suggestion(entity.getSystemSuggestion())
                                        .build())
                                .build())
                        .build();

                result.add(dto);
            }

            result.sort((a, b) -> {
                if (a.getStoppedAt() == null && b.getStoppedAt() == null) return 0;
                if (a.getStoppedAt() == null) return 1;
                if (b.getStoppedAt() == null) return -1;
                return b.getStoppedAt().compareTo(a.getStoppedAt());
            });

            log.info("Retrieved {} troubleshoot records for date {} and vmId {}", result.size(), date, vmId);
            return result;

        } catch (Exception e) {
            log.error("Failed to get troubleshoot data for date {} and vmId {}: {}", date, vmId, e.getMessage());
            return new ArrayList<>();
        }
    }

    private String extractHealthData(String fullResponse) {
        try {
            log.debug("Extracting health data from response");

            if (fullResponse == null) {
                log.warn("Full response is null");
                return null;
            }

            String searchFor = "\"Clean output\"";
            int index = fullResponse.indexOf(searchFor);

            if (index == -1) {
                log.warn("Clean output not found in response");
                return null;
            }

            int jsonStart = fullResponse.indexOf("\"json\"", index);
            if (jsonStart == -1) {
                log.warn("json field not found after Clean output");
                return null;
            }

            int objectStart = fullResponse.indexOf("{", jsonStart);
            if (objectStart == -1) {
                log.warn("JSON start not found");
                return null;
            }

            int braceCount = 0;
            int objectEnd = -1;
            for (int i = objectStart; i < fullResponse.length(); i++) {
                if (fullResponse.charAt(i) == '{') {
                    braceCount++;
                } else if (fullResponse.charAt(i) == '}') {
                    braceCount--;
                    if (braceCount == 0) {
                        objectEnd = i + 1;
                        break;
                    }
                }
            }

            if (objectEnd == -1) {
                log.warn("JSON end not found");
                return null;
            }

            String json = fullResponse.substring(objectStart, objectEnd);
            log.info("Extracted JSON length: {}", json.length());

            return json;

        } catch (Exception e) {
            log.error("Error extracting health data: {}", e.getMessage(), e);
            return null;
        }
    }

    private String extractExecutionId(String fullResponse) {
        try {
            String searchFor = "\"id\":\"";
            int index = fullResponse.indexOf(searchFor);
            if (index == -1) return null;
            int start = index + searchFor.length();
            int end = fullResponse.indexOf("\"", start);
            return fullResponse.substring(start, end);
        } catch (Exception e) {
            return null;
        }
    }

    private LocalDateTime extractStartedAt(String fullResponse) {
        try {
            String searchFor = "\"startedAt\":\"";
            int index = fullResponse.indexOf(searchFor);
            if (index == -1) return null;
            int start = index + searchFor.length();
            int end = fullResponse.indexOf("\"", start);
            String dateStr = fullResponse.substring(start, end);
            return parseDateTime(dateStr);
        } catch (Exception e) {
            return null;
        }
    }

    private LocalDateTime extractStoppedAt(String fullResponse) {
        try {
            String searchFor = "\"stoppedAt\":\"";
            int index = fullResponse.indexOf(searchFor);
            if (index == -1) return null;
            int start = index + searchFor.length();
            int end = fullResponse.indexOf("\"", start);
            String dateStr = fullResponse.substring(start, end);
            return parseDateTime(dateStr);
        } catch (Exception e) {
            return null;
        }
    }

    private String extractExecutionStatus(String fullResponse) {
        try {
            String searchFor = "\"status\":\"";
            int index = fullResponse.indexOf(searchFor);
            if (index == -1) return null;
            int start = index + searchFor.length();
            int end = fullResponse.indexOf("\"", start);
            return fullResponse.substring(start, end);
        } catch (Exception e) {
            return null;
        }
    }

    private LocalDateTime parseDateTime(String dateStr) {
        try {
            String cleaned = dateStr.replace("Z", "");
            return LocalDateTime.parse(cleaned, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        } catch (Exception e) {
            log.warn("Failed to parse date: {}", dateStr);
            return null;
        }
    }

    private Troubleshoot mapToEntity(TroubleshootDto dto) {
        Troubleshoot entity = new Troubleshoot();
        entity.setVmId(4L);
        entity.setExecutionId(dto.getExecutionId());
        entity.setSummary(dto.getSummary());
        entity.setSeverity(dto.getSeverity());
        entity.setAction(dto.getAction());
        entity.setCreatedAt(LocalDateTime.now());
        entity.setStartedAt(dto.getStartedAt());
        entity.setStoppedAt(dto.getStoppedAt());
        entity.setExecutionStatus(dto.getExecutionStatus());

        if (dto.getComponents() != null) {
            if (dto.getComponents().getSpring_boot() != null) {
                entity.setSpringBootStatus(dto.getComponents().getSpring_boot().getStatus());
                entity.setSpringBootDetails(dto.getComponents().getSpring_boot().getDetails());
                entity.setSpringBootSuggestion(dto.getComponents().getSpring_boot().getSuggestion());
            }

            if (dto.getComponents().getSyslog() != null) {
                entity.setSyslogStatus(dto.getComponents().getSyslog().getStatus());
                entity.setSyslogDetails(dto.getComponents().getSyslog().getDetails());
                entity.setSyslogSuggestion(dto.getComponents().getSyslog().getSuggestion());
            }

            if (dto.getComponents().getPm2() != null) {
                entity.setPm2Status(dto.getComponents().getPm2().getStatus());
                entity.setPm2Details(dto.getComponents().getPm2().getDetails());
                entity.setPm2Suggestion(dto.getComponents().getPm2().getSuggestion());
            }

            if (dto.getComponents().getNginx() != null) {
                entity.setNginxStatus(dto.getComponents().getNginx().getStatus());
                entity.setNginxDetails(dto.getComponents().getNginx().getDetails());
                entity.setNginxSuggestion(dto.getComponents().getNginx().getSuggestion());
            }

            if (dto.getComponents().getPostgresql() != null) {
                entity.setPostgresqlStatus(dto.getComponents().getPostgresql().getStatus());
                entity.setPostgresqlDetails(dto.getComponents().getPostgresql().getDetails());
                entity.setPostgresqlSuggestion(dto.getComponents().getPostgresql().getSuggestion());
            }

            if (dto.getComponents().getSystem() != null) {
                entity.setUptime(dto.getComponents().getSystem().getUptime());
                entity.setMemory(dto.getComponents().getSystem().getMemory());
                entity.setDisk(dto.getComponents().getSystem().getDisk());
                entity.setCpu(dto.getComponents().getSystem().getCpu());
                entity.setNetwork(dto.getComponents().getSystem().getNetwork());
                entity.setSystemStatus(dto.getComponents().getSystem().getStatus());
                entity.setSystemDetails(dto.getComponents().getSystem().getDetails());
                entity.setSystemSuggestion(dto.getComponents().getSystem().getSuggestion());
            }
        }

        return entity;
    }
}