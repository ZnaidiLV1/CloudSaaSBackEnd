package org.example.service;

import com.azure.resourcemanager.costmanagement.CostManagementManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.invoiceVmCostDTOs.CostByMeterDto;
import org.example.dto.invoiceVmCostDTOs.CostByServiceDto;
import org.example.dto.invoiceVmCostDTOs.SharedCostByServiceDto;
import org.example.dto.invoiceVmCostDTOs.SharedCostsResponse;
import org.example.repository.MonthlyCostRepository;
import org.example.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
public class  MonthlyCostGetGrouped{

    private final CostManagementManager costManagementManager;
    private final MonthlyCostRepository monthlyCostRepository;
    private final VmRepository vmRepository;

    private static final BigDecimal THRESHOLD = new BigDecimal("5.00");

    @Transactional(readOnly = true)
    public List<CostByServiceDto> getTotalCostsByService(int year, int month) {
        log.info("Getting total costs by service for {}-{}", year, month);

        List<Object[]> results = monthlyCostRepository.sumCostsByService(month, year);

        if (results == null || results.isEmpty()) {
            log.warn("No cost data found for {}-{}", year, month);
            return Collections.emptyList();
        }

        List<CostByServiceDto> mainItems = new ArrayList<>();
        BigDecimal otherTotal = BigDecimal.ZERO;

        for (Object[] row : results) {
            String serviceName = (String) row[0];
            BigDecimal cost = (BigDecimal) row[1];

            if (cost.compareTo(THRESHOLD) > 0) {
                mainItems.add(CostByServiceDto.builder()
                        .serviceName(serviceName)
                        .totalCost(cost.setScale(2, RoundingMode.HALF_UP).doubleValue())
                        .build());
            } else {
                otherTotal = otherTotal.add(cost);
            }
        }

        if (otherTotal.compareTo(BigDecimal.ZERO) > 0) {
            mainItems.add(CostByServiceDto.builder()
                    .serviceName("Other")
                    .totalCost(otherTotal.setScale(2, RoundingMode.HALF_UP).doubleValue())
                    .build());
        }

        mainItems.sort((a, b) -> Double.compare(b.getTotalCost(), a.getTotalCost()));

        return mainItems;
    }

    @Transactional(readOnly = true)
    public List<CostByMeterDto> getTotalCostsByMeter(int year, int month) {

        List<Object[]> results = monthlyCostRepository.sumCostsByMeter(month, year);

        if (results == null || results.isEmpty()) {
            return Collections.emptyList();
        }

        List<CostByMeterDto> mainItems = new ArrayList<>();
        BigDecimal otherTotal = BigDecimal.ZERO;

        for (Object[] row : results) {
            String meterName = (String) row[0];
            BigDecimal cost = (BigDecimal) row[1];

            if (meterName != null && meterName.contains("[RESERVATION]")) {
                mainItems.add(CostByMeterDto.builder()
                        .meterName(meterName)
                        .totalCost(cost.setScale(2, RoundingMode.HALF_UP).doubleValue())
                        .build());
            }
            else if (cost.compareTo(THRESHOLD) > 0) {
                mainItems.add(CostByMeterDto.builder()
                        .meterName(meterName)
                        .totalCost(cost.setScale(2, RoundingMode.HALF_UP).doubleValue())
                        .build());
            } else {
                otherTotal = otherTotal.add(cost);
            }
        }

        if (otherTotal.compareTo(BigDecimal.ZERO) > 0) {
            mainItems.add(CostByMeterDto.builder()
                    .meterName("Other")
                    .totalCost(otherTotal.setScale(2, RoundingMode.HALF_UP).doubleValue())
                    .build());
        }

        mainItems.sort((a, b) -> Double.compare(b.getTotalCost(), a.getTotalCost()));

        return mainItems;
    }

    @Transactional(readOnly = true)
    public SharedCostsResponse getSharedCostsByService(int year, int month) {
        log.info("Getting shared costs by service for {}-{}", year, month);

        List<Object[]> results = monthlyCostRepository.findSharedCostsByService(year, month);

        if (results == null || results.isEmpty()) {
            log.warn("No shared cost data found for {}-{}", year, month);
            return SharedCostsResponse.builder()
                    .year(year)
                    .month(month)
                    .sharedCostsByService(Collections.emptyList())
                    .build();
        }

        List<SharedCostByServiceDto> sharedCosts = new ArrayList<>();

        for (Object[] row : results) {
            String serviceName = (String) row[0];
            BigDecimal cost = (BigDecimal) row[1];

            sharedCosts.add(SharedCostByServiceDto.builder()
                    .serviceName(serviceName)
                    .totalCost(cost.setScale(2, RoundingMode.HALF_UP).doubleValue())
                    .build());
        }

        return SharedCostsResponse.builder()
                .year(year)
                .month(month)
                .sharedCostsByService(sharedCosts)
                .build();
    }
}