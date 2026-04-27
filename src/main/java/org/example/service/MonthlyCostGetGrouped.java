package org.example.service;

import com.azure.resourcemanager.costmanagement.CostManagementManager;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.costDTOs.ServiceCostData;
import org.example.dto.costDTOs.ServiceCostsResponse;
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
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

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

    @Transactional(readOnly = true)
    public ServiceCostsResponse getCostsByServiceName(String startDate, String endDate, String serviceName) {
        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);

        if (start.isAfter(end)) {
            LocalDate temp = start;
            start = end;
            end = temp;
        }

        List<String> monthsList = new ArrayList<>();
        List<Integer> yearMonthList = new ArrayList<>();

        LocalDate current = start;
        while (!current.isAfter(end)) {
            int year = current.getYear();
            int month = current.getMonthValue();
            monthsList.add(String.format("%d-%02d", year, month));
            yearMonthList.add(year * 100 + month);
            current = current.plusMonths(1);
        }

        List<String> allServiceNames = monthlyCostRepository.findAllDistinctServiceNamesIncludingVirtualMachines();
        List<ServiceCostData> servicesCosts = new ArrayList<>();

        if (serviceName == null || serviceName.equalsIgnoreCase("ALL")) {
            Map<String, List<Double>> costsByService = new HashMap<>();

            for (String svc : allServiceNames) {
                costsByService.put(svc, new ArrayList<>());
            }

            for (int ym : yearMonthList) {
                int year = ym / 100;
                int month = ym % 100;

                List<Object[]> results = monthlyCostRepository.sumCostsByServiceForMonth(year, month);
                Map<String, Double> monthCosts = new HashMap<>();

                for (Object[] row : results) {
                    String svc = (String) row[0];
                    BigDecimal cost = (BigDecimal) row[1];
                    monthCosts.put(svc, cost.setScale(2, RoundingMode.HALF_UP).doubleValue());
                }

                for (String svc : allServiceNames) {
                    double cost = monthCosts.getOrDefault(svc, 0.0);
                    costsByService.get(svc).add(cost);
                }
            }

            List<String> filteredServiceNames = new ArrayList<>();
            for (String svc : allServiceNames) {
                List<Double> costs = costsByService.get(svc);
                boolean hasNonZero = costs.stream().anyMatch(c -> c > 0);
                if (hasNonZero) {
                    filteredServiceNames.add(svc);
                    servicesCosts.add(ServiceCostData.builder()
                            .serviceName(svc)
                            .costs(costs)
                            .build());
                }
            }

            return ServiceCostsResponse.builder()
                    .serviceNames(filteredServiceNames)
                    .months(monthsList)
                    .services(servicesCosts)
                    .build();

        } else {
            for (int ym : yearMonthList) {
                int year = ym / 100;
                int month = ym % 100;

                BigDecimal cost = monthlyCostRepository.sumCostsByServiceNameForMonth(year, month, serviceName);
                double costValue = cost != null ? cost.setScale(2, RoundingMode.HALF_UP).doubleValue() : 0.0;

                ServiceCostData existing = servicesCosts.stream()
                        .filter(s -> s.getServiceName().equals(serviceName))
                        .findFirst()
                        .orElse(null);

                if (existing == null) {
                    List<Double> costs = new ArrayList<>();
                    costs.add(costValue);
                    servicesCosts.add(ServiceCostData.builder()
                            .serviceName(serviceName)
                            .costs(costs)
                            .build());
                } else {
                    existing.getCosts().add(costValue);
                }
            }

            return ServiceCostsResponse.builder()
                    .serviceNames(allServiceNames)
                    .months(monthsList)
                    .services(servicesCosts)
                    .build();
        }
    }

    private LocalDate parseDate(String dateStr) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return LocalDate.parse(dateStr, formatter);
    }
}