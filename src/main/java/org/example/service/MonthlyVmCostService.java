package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.invoiceVmCostDTOs.*;
import org.example.entity.MonthlyCost;
import org.example.entity.MonthlyVmCost;
import org.example.entity.Vm;
import org.example.repository.MonthlyCostRepository;
import org.example.repository.MonthlyVmCostRepository;
import org.example.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class MonthlyVmCostService {

    private final MonthlyCostRepository monthlyCostRepository;
    private final MonthlyVmCostRepository monthlyVmCostRepository;
    private final VmRepository vmRepository;
    public final PerformanceService performanceService;

    @Transactional
    public String calculateMonthlyVmCosts(int year, int month) {
        log.info("Calculating monthly VM costs for {}-{}", year, month);

        List<Vm> allVms = vmRepository.findAll();
        if (allVms.isEmpty()) {
            return "No VMs found in database";
        }
        int totalVmCount = allVms.size();

        Map<Long, Double> availabilityMap = performanceService.getAvailabilityByMonth(month, year);

        List<MonthlyCost> allCosts = monthlyCostRepository.findByMonthAndYear(month, year);

        Map<Long, BigDecimal> directCosts = allCosts.stream()
                .filter(c -> c.getVmId() != null)
                .collect(Collectors.groupingBy(
                        MonthlyCost::getVmId,
                        Collectors.mapping(MonthlyCost::getCost,
                                Collectors.reducing(BigDecimal.ZERO, BigDecimal::add))
                ));

        BigDecimal totalSharedCost = allCosts.stream()
                .filter(c -> c.getVmId() == null && c.getIsShared() != null && c.getIsShared())
                .filter(c -> !c.getMeterName().contains("[RESERVATION]"))
                .map(MonthlyCost::getCost)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal sharedCostPerVm = totalSharedCost.divide(BigDecimal.valueOf(totalVmCount), 15, RoundingMode.HALF_UP);

        List<MonthlyCost> reservations = allCosts.stream()
                .filter(c -> c.getMeterName().contains("[RESERVATION]"))
                .toList();

        Map<String, List<Vm>> reservationVmsByType = allVms.stream()
                .filter(vm -> vm.getBillingType() != null && "RESERVATION".equals(vm.getBillingType().name()))
                .collect(Collectors.groupingBy(Vm::getVmType));

        Map<Long, BigDecimal> reservationCosts = new HashMap<>();

        for (MonthlyCost reservation : reservations) {
            String vmType = reservation.getMeterName().replace("[RESERVATION] ", "").trim();
            BigDecimal totalReservationCost = reservation.getCost();

            List<Vm> matchingVms = reservationVmsByType.getOrDefault(vmType, new ArrayList<>());
            if (matchingVms.isEmpty()) {
                log.warn("No RESERVATION VMs found for type: {}", vmType);
                continue;
            }

            int reservationVmCount = matchingVms.size();
            BigDecimal reservationSharePerVm = totalReservationCost.divide(BigDecimal.valueOf(reservationVmCount), 15, RoundingMode.HALF_UP);

            for (Vm vm : matchingVms) {
                reservationCosts.merge(vm.getId(), reservationSharePerVm, BigDecimal::add);
            }
        }

        monthlyVmCostRepository.deleteByMonthAndYear(month, year);

        List<MonthlyVmCost> costsToSave = new ArrayList<>();
        for (Vm vm : allVms) {
            Long vmId = vm.getId();
            BigDecimal direct = directCosts.getOrDefault(vmId, BigDecimal.ZERO);
            BigDecimal reservation = reservationCosts.getOrDefault(vmId, BigDecimal.ZERO);
            BigDecimal shared = sharedCostPerVm;
            BigDecimal total = direct.add(reservation).add(shared);
            Double availability = availabilityMap.getOrDefault(vmId, 100.0);

            MonthlyVmCost vmCost = MonthlyVmCost.builder()
                    .vm(vm)
                    .month(month)
                    .year(year)
                    .directCost(direct)
                    .reservationCost(reservation)
                    .sharedCost(shared)
                    .totalCost(total)
                    .availabilityPercent(availability)
                    .calculatedAt(LocalDateTime.now())
                    .build();

            costsToSave.add(vmCost);
        }

        monthlyVmCostRepository.saveAll(costsToSave);

        log.info("Saved {} records for {}-{}", costsToSave.size(), year, month);
        return String.format("Successfully calculated and saved costs for %d VMs for month %d/%d",
                costsToSave.size(), month, year);
        
    }
    @Transactional(readOnly = true)
    public VmCostHistoryResponse getVmCostHistory(int index) {
        int monthsPerPage = 6;

        List<Object[]> distinctMonths = monthlyVmCostRepository.findDistinctYearMonths();

        if (distinctMonths.isEmpty()) {
            return VmCostHistoryResponse.builder()
                    .vmCostHistory(List.of())
                    .index(index)
                    .hasNext(false)
                    .hasPrevious(false)
                    .months(List.of())
                    .build();
        }

        List<Integer> allYearMonths = distinctMonths.stream()
                .map(arr -> (int)arr[0] * 100 + (int)arr[1])
                .sorted(Collections.reverseOrder())
                .collect(Collectors.toList());

        int startIndex = index * monthsPerPage;
        int endIndex = Math.min(startIndex + monthsPerPage, allYearMonths.size());

        if (startIndex >= allYearMonths.size()) {
            return VmCostHistoryResponse.builder()
                    .vmCostHistory(List.of())
                    .index(index)
                    .hasNext(false)
                    .hasPrevious(index > 0)
                    .months(List.of())
                    .build();
        }

        List<Integer> windowYearMonths = allYearMonths.subList(startIndex, endIndex);

        
        List<String> sharedMonths = windowYearMonths.stream()
                .map(yearMonth -> {
                    int year = yearMonth / 100;
                    int month = yearMonth % 100;
                    return String.format("%d-%02d", year, month);
                })
                .collect(Collectors.toList());

        int minYearMonth = windowYearMonths.get(windowYearMonths.size() - 1);
        int maxYearMonth = windowYearMonths.get(0);

        List<MonthlyVmCost> costsInWindow = monthlyVmCostRepository.findByYearMonthRange(minYearMonth, maxYearMonth);

        Map<Long, List<MonthlyVmCost>> costsByVm = costsInWindow.stream()
                .collect(Collectors.groupingBy(c -> c.getVm().getId()));

        List<VmCostHistoryResponse.VmCostHistory> vmCostHistories = new ArrayList<>();

        for (Map.Entry<Long, List<MonthlyVmCost>> entry : costsByVm.entrySet()) {
            Long vmId = entry.getKey();
            List<MonthlyVmCost> vmCosts = entry.getValue();

            String vmName = vmRepository.findById(vmId)
                    .map(Vm::getName)
                    .orElse("Unknown VM");

            Map<Integer, BigDecimal> costByYearMonth = vmCosts.stream()
                    .collect(Collectors.toMap(
                            c -> c.getYear() * 100 + c.getMonth(),
                            MonthlyVmCost::getTotalCost
                    ));

            List<Double> orderedCosts = new ArrayList<>();

            for (int yearMonth : windowYearMonths) {
                BigDecimal cost = costByYearMonth.getOrDefault(yearMonth, BigDecimal.ZERO);
                double roundedCost = cost.setScale(2, RoundingMode.HALF_UP).doubleValue();
                orderedCosts.add(roundedCost);
            }

            vmCostHistories.add(VmCostHistoryResponse.VmCostHistory.builder()
                    .vmId(vmId)
                    .vmName(vmName)
                    .costs(orderedCosts)
                    .build());
        }

        boolean hasNext = endIndex < allYearMonths.size();
        boolean hasPrevious = index > 0;

        return VmCostHistoryResponse.builder()
                .vmCostHistory(vmCostHistories)
                .index(index)
                .hasNext(hasNext)
                .hasPrevious(hasPrevious)
                .months(sharedMonths)  
                .build();
    }

    @Transactional(readOnly = true)
    public List<VmCostByMonthDto> getVmCostsByMonthAndYear(Integer year, Integer month) {
        log.info("Fetching VM costs for year: {}, month: {}", year, month);

        List<MonthlyVmCost> costs;

        if (year != null && month != null) {
            costs = monthlyVmCostRepository.findByYearAndMonth(year, month);
        } else if (year != null) {
            costs = monthlyVmCostRepository.findByYear(year);
        } else if (month != null) {
            costs = monthlyVmCostRepository.findByMonth(month);
        } else {
            costs = monthlyVmCostRepository.findAll();
        }

        List<VmCostByMonthDto> result = costs.stream()
                .map(cost -> VmCostByMonthDto.builder()
                        .vmId(cost.getVm().getId())
                        .vmName(cost.getVm().getName())
                        .totalCost(cost.getTotalCost().setScale(2, RoundingMode.HALF_UP).doubleValue())
                        .build())
                .collect(Collectors.toList());

        log.info("Found {} VM costs for year: {}, month: {}", result.size(), year, month);
        return result;
    }

    @Transactional(readOnly = true)
    public VmCostDetailDto getVmCostDetail(Long vmId, int year, int month) {
        log.info("Getting VM cost detail for VM: {}, year: {}, month: {}", vmId, year, month);

        Optional<MonthlyVmCost> costOpt = monthlyVmCostRepository.findByVmIdAndYearAndMonth(vmId, year, month);

        if (costOpt.isEmpty()) {
            log.warn("No cost data found for VM: {}, year: {}, month: {}", vmId, year, month);
            return VmCostDetailDto.builder()
                    .vmId(vmId)
                    .vmName("Unknown")
                    .directCost(0.0)
                    .reservationCost(0.0)
                    .sharedCost(0.0)
                    .totalCost(0.0)
                    .build();
        }

        MonthlyVmCost cost = costOpt.get();

        return VmCostDetailDto.builder()
                .vmId(cost.getVm().getId())
                .vmName(cost.getVm().getName())
                .directCost(cost.getDirectCost().setScale(2, RoundingMode.HALF_UP).doubleValue())
                .reservationCost(cost.getReservationCost().setScale(2, RoundingMode.HALF_UP).doubleValue())
                .sharedCost(cost.getSharedCost().setScale(2, RoundingMode.HALF_UP).doubleValue())
                .totalCost(cost.getTotalCost().setScale(2, RoundingMode.HALF_UP).doubleValue())
                .build();
    }

    @Transactional(readOnly = true)
    public List<VmCostByServiceDto> getVmCostsByServiceForVm(Long vmId, int year, int month) {
        log.info("Getting VM costs by service for VM: {}, year: {}, month: {}", vmId, year, month);

        List<Object[]> results = monthlyCostRepository.findCostsByServiceForVm(year, month, vmId);

        if (results == null || results.isEmpty()) {
            log.warn("No service cost data found for VM: {}, year: {}, month: {}", vmId, year, month);
            return Collections.emptyList();
        }

        List<VmCostByServiceDto> serviceCosts = new ArrayList<>();

        for (Object[] row : results) {
            String serviceName = (String) row[0];
            BigDecimal cost = (BigDecimal) row[1];

            serviceCosts.add(VmCostByServiceDto.builder()
                    .serviceName(serviceName)
                    .totalCost(cost.setScale(2, RoundingMode.HALF_UP).doubleValue())
                    .build());
        }

        return serviceCosts;
    }

    @Transactional(readOnly = true)
    public MonthlyCostRangeResponseDto getMonthlyCostsByDateRange(Long vmId, String startDate, String endDate) {
        log.info("Getting monthly costs for vmId: {}, startDate: {}, endDate: {}", vmId, startDate, endDate);

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

        if (vmId != null && vmId != 0) {
            Optional<Vm> vmOpt = vmRepository.findById(vmId);
            if (vmOpt.isEmpty()) {
                throw new RuntimeException("VM not found with id: " + vmId);
            }
            Vm vm = vmOpt.get();

            List<MonthlyVmCost> costs = monthlyVmCostRepository.findByYearMonthRange(
                    yearMonthList.get(0),
                    yearMonthList.get(yearMonthList.size() - 1)
            );

            costs = costs.stream()
                    .filter(c -> c.getVm().getId().equals(vmId))
                    .collect(Collectors.toList());

            Map<Integer, BigDecimal> costMap = costs.stream()
                    .collect(Collectors.toMap(
                            c -> c.getYear() * 100 + c.getMonth(),
                            MonthlyVmCost::getTotalCost,
                            (a, b) -> a
                    ));

            List<Double> costValues = new ArrayList<>();
            for (int ym : yearMonthList) {
                BigDecimal cost = costMap.getOrDefault(ym, BigDecimal.ZERO);
                costValues.add(cost.setScale(2, RoundingMode.HALF_UP).doubleValue());
            }

            return MonthlyCostRangeResponseDto.builder()
                    .isAllVms(false)
                    .vmId(vmId)
                    .vmName(vm.getName())
                    .months(monthsList)
                    .costs(costValues)
                    .build();

        } else {
            List<Vm> allVms = vmRepository.findAll();

            List<MonthlyVmCost> allCosts = monthlyVmCostRepository.findByYearMonthRange(
                    yearMonthList.get(0),
                    yearMonthList.get(yearMonthList.size() - 1)
            );

            Map<Long, Map<Integer, BigDecimal>> costsByVmAndMonth = new HashMap<>();

            for (MonthlyVmCost cost : allCosts) {
                Long id = cost.getVm().getId();
                int ym = cost.getYear() * 100 + cost.getMonth();

                costsByVmAndMonth.computeIfAbsent(id, k -> new HashMap<>())
                        .put(ym, cost.getTotalCost());
            }

            List<VmMonthlyCostData> vmCostsList = new ArrayList<>();

            for (Vm vm : allVms) {
                Map<Integer, BigDecimal> vmCostMap = costsByVmAndMonth.getOrDefault(vm.getId(), new HashMap<>());

                List<Double> costValues = new ArrayList<>();
                for (int ym : yearMonthList) {
                    BigDecimal cost = vmCostMap.getOrDefault(ym, BigDecimal.ZERO);
                    costValues.add(cost.setScale(2, RoundingMode.HALF_UP).doubleValue());
                }

                vmCostsList.add(VmMonthlyCostData.builder()
                        .vmId(vm.getId())
                        .vmName(vm.getName())
                        .costs(costValues)
                        .build());
            }

            return MonthlyCostRangeResponseDto.builder()
                    .isAllVms(true)
                    .months(monthsList)
                    .vmCosts(vmCostsList)
                    .build();
        }
    }

    @Transactional(readOnly = true)
    public VmCostHistoryDto getVmCostHistoryByDateRange(Long vmId, String startDate, String endDate) {

        LocalDate start = parseDate(startDate);
        LocalDate end = parseDate(endDate);

        Vm vm = vmRepository.findById(vmId)
                .orElseThrow(() -> new RuntimeException("VM not found with id: " + vmId));

        List<MonthlyVmCost> allCosts = monthlyVmCostRepository.findByVmIdOrderByYearMonthDesc(vmId);

        List<DailyCostDto> costs = new ArrayList<>();

        LocalDate current = start;
        while (!current.isAfter(end)) {
            int year = current.getYear();
            int month = current.getMonthValue();

            Double totalCost = allCosts.stream()
                    .filter(c -> c.getYear() == year && c.getMonth() == month)
                    .map(MonthlyVmCost::getTotalCost)
                    .map(BigDecimal::doubleValue)
                    .findFirst()
                    .orElse(0.0);

            costs.add(DailyCostDto.builder()
                    .date(current.toString())
                    .totalCost(Math.round(totalCost * 100.0) / 100.0)
                    .build());

            current = current.plusMonths(1);
        }

        return VmCostHistoryDto.builder()
                .vmId(vmId)
                .vmName(vm.getName())
                .costs(costs)
                .build();
    }

    private LocalDate parseDate(String dateStr) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return LocalDate.parse(dateStr, formatter);
    }

}