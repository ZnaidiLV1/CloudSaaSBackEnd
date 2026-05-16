package org.example.azure.service;

import lombok.RequiredArgsConstructor;
import org.example.azure.entity.CostRecord;
import org.example.azure.repository.CostRecordRepository;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CostService {

    private final CostRecordRepository costRecordRepository;
    private final AzureCostService azureCostService;
    public void syncDailyCostsFromAzure() {
        azureCostService.syncDailyCostsFromAzure();
    }

    public List<CostRecord> getCostsForVm(
            Long vmId, LocalDate from, LocalDate to) {
        return costRecordRepository.findByVmIdAndDateBetween(vmId, from, to);
    }

    public Double getTotalCostForVm(
            Long vmId, LocalDate from, LocalDate to) {
        return costRecordRepository.totalCostByVmAndPeriod(vmId, from, to);
    }

    public List<Object[]> getCostBreakdownByProduct(
            String product, LocalDate from, LocalDate to) {
        return costRecordRepository.totalCostByTypeAndProduct(
                product, from, to);
    }
}