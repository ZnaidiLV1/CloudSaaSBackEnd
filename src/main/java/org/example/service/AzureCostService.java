package org.example.service;

import com.azure.resourcemanager.costmanagement.CostManagementManager;
import com.azure.resourcemanager.costmanagement.models.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.*;
import org.example.enums.CostType;
import org.example.repository.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.*;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AzureCostService {

    private final CostManagementManager costManager;
    private final VmRepository vmRepository;
    private final CostRecordRepository costRecordRepository;

    @Value("${azure.subscription-id}")
    private String subscriptionId;

    public void syncDailyCostsFromAzure() {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        String scope = "/subscriptions/" + subscriptionId;

        log.info("=== Starting cost sync for date: {} ===", yesterday);
        log.info("Scope: {}", scope);

        try {
            QueryResult result = costManager.queries().usage(
                    scope,
                    new QueryDefinition()
                            .withType(ExportType.ACTUAL_COST)
                            .withTimeframe(TimeframeType.CUSTOM)
                            .withTimePeriod(new QueryTimePeriod()
                                    .withFrom(yesterday.atStartOfDay()
                                            .atOffset(ZoneOffset.UTC))
                                    .withTo(yesterday.atTime(23, 59, 59)
                                            .atOffset(ZoneOffset.UTC)))
                            .withDataset(new QueryDataset()
                                    .withGranularity(GranularityType.DAILY)
                                    // ✅ ADDED AGGREGATION - this gets the actual cost amount
                                    .withAggregation(Map.of(
                                            "totalCost", new QueryAggregation()
                                                    .withName("Cost")
                                                    .withFunction(FunctionType.fromString("Sum"))  // Use "Sum" as string
                                    ))
                                    .withGrouping(List.of(
                                            new QueryGrouping()
                                                    .withType(QueryColumnType.DIMENSION)
                                                    .withName("ResourceId"),
                                            new QueryGrouping()
                                                    .withType(QueryColumnType.DIMENSION)
                                                    .withName("MeterCategory")
                                    ))
                            )
            );

            if (result == null) {
                log.warn("Result is null - no data returned from Azure");
                return;
            }

            if (result.rows() == null) {
                log.warn("Rows is null - no rows in result");
                return;
            }

            log.info("Total rows returned from Azure: {}", result.rows().size());

            // Log the column names to understand the structure
            if (result.columns() != null) {
                log.info("Column names: {}", result.columns().stream()
                        .map(col -> col.name())
                        .collect(Collectors.toList()));
            }

            List<Vm> vms = vmRepository.findAll();
            log.info("Found {} VMs in database", vms.size());

            AtomicInteger matchedCount = new AtomicInteger();
            AtomicInteger savedCount = new AtomicInteger();

            for (List<Object> row : result.rows()) {
                try {
                    if (row.size() >= 5) {
                        // ✅ FIXED: Use correct indices based on column order
                        Double amount = parseDouble(row.get(0));        // Cost
                        String usageDate = String.valueOf(row.get(1));  // UsageDate (not needed)
                        String resourceId = String.valueOf(row.get(2)); // ResourceId ✅
                        String meterCategory = String.valueOf(row.get(3)); // MeterCategory ✅
                        String currency = String.valueOf(row.get(4));   // Currency (not needed)

                        log.info("Amount: ${}, ResourceId: {}, MeterCategory: {}",
                                amount, resourceId, meterCategory);

                        // Skip if amount is 0 or null
                        if (amount == null || amount == 0.0) {
                            log.debug("Skipping zero-cost record for: {}", resourceId);
                            continue;
                        }

                        // Find matching VM
                        Vm matchingVm = vms.stream()
                                .filter(v -> v.getAzureVmId() != null &&
                                        v.getAzureVmId().equalsIgnoreCase(resourceId))
                                .findFirst()
                                .orElse(null);

                        if (matchingVm != null) {
                            matchedCount.getAndIncrement();
                            CostType costType = mapMeterToCostType(meterCategory);

                            // Check if already exists
                            boolean exists = costRecordRepository
                                    .findByVmIdAndDate(matchingVm.getId(), yesterday)
                                    .stream()
                                    .anyMatch(c -> c.getCostType() == costType);

                            if (!exists) {
                                CostRecord record = CostRecord.builder()
                                        .vm(matchingVm)
                                        .costType(costType)
                                        .amount(amount)
                                        .currency("USD")
                                        .date(yesterday)
                                        .build();
                                costRecordRepository.save(record);
                                savedCount.getAndIncrement();
                                log.info("✅ Saved cost record: VM={}, Type={}, Amount=${}",
                                        matchingVm.getName(), costType, amount);
                            }
                        } else {
                            log.debug("❌ No VM found with azureVmId: {}", resourceId);
                        }
                    } else {
                        log.warn("Row has unexpected size: {}", row.size());
                    }
                } catch (Exception e) {
                    log.error("Error processing row: {}", e.getMessage(), e);
                }
            }

            log.info("=== Cost sync completed - Matched: {}, Saved: {}, Total rows: {} ===",
                    matchedCount.get(), savedCount.get(), result.rows().size());

        } catch (Exception e) {
            log.error("Failed to sync costs from Azure", e);
            throw e;
        }
    }

    private CostType mapMeterToCostType(String meterCategory) {
        if (meterCategory == null) return CostType.OTHER;
        return switch (meterCategory.toLowerCase()) {
            case "virtual machines" -> CostType.COMPUTE;
            case "storage" -> CostType.DISK;
            case "backup" -> CostType.BACKUP;
            case "ip addresses" -> CostType.PUBLIC_IP;
            case "bandwidth" -> CostType.NETWORK;
            default -> CostType.OTHER;
        };
    }

    private Double parseDouble(Object obj) {
        if (obj == null) return 0.0;
        try {
            return Double.parseDouble(obj.toString());
        } catch (NumberFormatException e) {
            return 0.0;
        }
    }
}