package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
import java.time.LocalDateTime;
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
}