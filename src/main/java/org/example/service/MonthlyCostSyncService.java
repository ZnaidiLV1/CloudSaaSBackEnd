package org.example.service;

import com.azure.resourcemanager.costmanagement.CostManagementManager;
import com.azure.resourcemanager.costmanagement.models.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.entity.MonthlyCost;
import org.example.repository.MonthlyCostRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
@RequiredArgsConstructor
public class MonthlyCostSyncService {

    private final CostManagementManager costManagementManager;
    private final MonthlyCostRepository costRepository;

    @Value("${azure.subscription-id}")
    private String subscriptionId;


    @Transactional
    public void syncLastMonthCosts() {
        LocalDate today = LocalDate.now();
        LocalDate firstDay = today.minusMonths(1).withDayOfMonth(1);
        LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth());

        int month = firstDay.getMonthValue();
        int year = firstDay.getYear();

        log.info("Syncing costs for {}-{} ({} to {})", year, month, firstDay, lastDay);

        try {
            if (costRepository.existsByMonthAndYear(month, year)) {
                log.info("Deleting existing data for {}-{}", year, month);
                costRepository.deleteByMonthAndYear(month, year);
            }

            List<MonthlyCost> costs = fetchCostsFromAzure(firstDay, lastDay, month, year);

            if (!costs.isEmpty()) {
                costRepository.saveAll(costs);
                log.info("Saved {} records for {}-{}", costs.size(), year, month);
            } else {
                log.warn("No cost data for {}-{}", year, month);
            }

        } catch (Exception e) {
            log.error("Cost sync failed for {}-{}: {}", year, month, e.getMessage(), e);
            throw new RuntimeException("Cost sync failed", e);
        }
    }


    public List<MonthlyCost> fetchCostsFromAzure(LocalDate startDate, LocalDate endDate, int month, int year) {
        List<MonthlyCost> costs = new ArrayList<>();

        String scope = String.format("/subscriptions/%s", subscriptionId);

        OffsetDateTime startDateTime = startDate.atStartOfDay().atOffset(ZoneOffset.UTC);
        OffsetDateTime endDateTime = endDate.atTime(23, 59, 59).atOffset(ZoneOffset.UTC);

        QueryDefinition queryDefinition = new QueryDefinition()
                .withType(ExportType.ACTUAL_COST)
                .withTimeframe(TimeframeType.CUSTOM)
                .withTimePeriod(new QueryTimePeriod()
                        .withFrom(startDateTime)
                        .withTo(endDateTime))
                .withDataset(new QueryDataset()
                        // ✅ Aggregation — this is what was missing, forces Azure to return Cost column
                        .withAggregation(Map.of(
                                "totalCost", new QueryAggregation()
                                        .withName("Cost")
                                        .withFunction(FunctionType.SUM)
                        ))
                        // ✅ No .withGranularity() — omitting it gives monthly totals, not daily rows
                        .withGrouping(List.of(
                                new QueryGrouping()
                                        .withType(QueryColumnType.DIMENSION)
                                        .withName("ServiceName"),
                                new QueryGrouping()
                                        .withType(QueryColumnType.DIMENSION)
                                        .withName("Meter")
                        )));

        try {
            QueryResult result = costManagementManager.queries().usage(scope, queryDefinition);

            if (result != null && result.rows() != null) {

                // Log raw first row so you can verify column order
                if (!result.rows().isEmpty()) {
                    log.info("RAW first row ({} cols): {}", result.rows().get(0).size(), result.rows().get(0));
                }

                for (List<Object> row : result.rows()) {
                    try {
                        // ✅ Correct column order WITH aggregation + no granularity:
                        // [0] = ServiceName
                        // [1] = Meter
                        // [2] = Cost (aggregated sum)
                        if (row.size() >= 3) {
                            BigDecimal cost    = parseCostValue(row.get(0));   // ✅ cost first
                            String serviceName = row.get(1) != null ? row.get(1).toString() : "Unknown";
                            String meterName   = row.get(2) != null ? row.get(2).toString() : "Unknown";
                            // row.get(3) = "USD" — ignore

                            if (cost.compareTo(BigDecimal.ZERO) > 0) {
                                costs.add(new MonthlyCost(
                                        null, month, year, meterName, serviceName,
                                        cost.setScale(2, RoundingMode.HALF_UP),
                                        LocalDateTime.now()
                                ));
                            }
                        }
                    } catch (Exception e) {
                        log.warn("Skipping bad row {}: {}", row, e.getMessage());
                    }
                }
            }

            log.info("Fetched {} records from Azure", costs.size());

        } catch (Exception e) {
            log.error("Azure fetch error: {}", e.getMessage(), e);
            throw e;
        }

        return costs;
    }


    private BigDecimal parseCostValue(Object costObject) {
        if (costObject == null) return BigDecimal.ZERO;
        try {
            if (costObject instanceof BigDecimal bd) return bd;
            if (costObject instanceof Number n) return BigDecimal.valueOf(n.doubleValue());
            String s = costObject.toString().trim().replaceAll("[^\\d.\\-]", "");
            return (s.isEmpty() || s.equals("-")) ? BigDecimal.ZERO : new BigDecimal(s);
        } catch (NumberFormatException e) {
            log.warn("Cannot parse cost '{}', using ZERO", costObject);
            return BigDecimal.ZERO;
        }
    }
}