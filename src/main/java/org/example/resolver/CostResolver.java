package org.example.resolver;

import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.CostByMeterDTO;
import org.example.dto.CostByServiceDTO;
import org.example.dto.TestCostResult;
import org.example.entity.MonthlyCost;
import org.example.repository.MonthlyCostRepository;
import org.example.service.MonthlyCostSyncService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Controller
@Slf4j
public class CostResolver {


    private final MonthlyCostRepository costRepository;
    private final MonthlyCostSyncService monthlyCostSyncService;


    @QueryMapping
    public List<CostByServiceDTO> getCostByService(@Argument Integer month, @Argument Integer year) {
        List<Object[]> results = costRepository.getCostByService(month, year);
        List<CostByServiceDTO> response = new ArrayList<>();

        for (Object[] row : results) {
            String serviceName = (String) row[0];
            BigDecimal totalCost = (BigDecimal) row[1];

            // Get meters for this service
            List<Object[]> meterResults = costRepository.getMetersByService(month, year, serviceName);
            List<CostByMeterDTO> meters = new ArrayList<>();

            for (Object[] meterRow : meterResults) {
                meters.add(new CostByMeterDTO(
                        (String) meterRow[0],
                        (String) meterRow[1],
                        (BigDecimal) meterRow[2]
                ));
            }

            response.add(new CostByServiceDTO(serviceName, totalCost, meters));
        }

        return response;
    }

    @QueryMapping
    public List<CostByMeterDTO> getAllMeters(@Argument Integer month, @Argument Integer year,
                                             @Argument Integer limit) {
        List<Object[]> results = costRepository.getAllMeters(month, year);
        List<CostByMeterDTO> meters = new ArrayList<>();

        int count = 0;
        for (Object[] row : results) {
            if (count >= limit) break;
            meters.add(new CostByMeterDTO(
                    (String) row[0],
                    (String) row[1],
                    (BigDecimal) row[2]
            ));
            count++;
        }

        return meters;
    }

    @QueryMapping
    public BigDecimal getTotalMonthlyCost(@Argument Integer month, @Argument Integer year) {
        return costRepository.getTotalCost(month, year);
    }

    @MutationMapping
    public List<TestCostResult> testFetchMonth(@Argument Integer year, @Argument Integer month) {
        log.info("TESTING fetch for {}-{} (no save)", year, month);

        // Calculate date range
        LocalDate firstDay = LocalDate.of(year, month, 1);
        LocalDate lastDay = firstDay.withDayOfMonth(firstDay.lengthOfMonth());

        // Fetch from Azure but DON'T save
        List<MonthlyCost> costs = monthlyCostSyncService.fetchCostsFromAzure(
                firstDay, lastDay, month, year
        );

        // Convert to test results
        List<TestCostResult> results = new ArrayList<>();
        for (MonthlyCost cost : costs) {
            results.add(new TestCostResult(
                    cost.getMeterName(),
                    cost.getServiceName(),
                    cost.getCost().doubleValue()
            ));
        }

        log.info("TEST: Retrieved {} records from Azure (not saved)", results.size());
        return results;
    }

    @MutationMapping
    public String syncLastMonthCosts(){
        monthlyCostSyncService.syncLastMonthCosts();
        return "good check db";
    }
}