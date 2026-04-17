package org.example.service;

import com.azure.resourcemanager.reservations.ReservationsManager;
import com.azure.resourcemanager.reservations.models.ReservationOrderResponse;
import com.azure.resourcemanager.reservations.models.ReservationResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.ReservationDTOs.ReservationDto;
import org.example.dto.ReservationDTOs.ReservationWithVmsDto;
import org.example.entity.Reservation;
import org.example.entity.Vm;
import org.example.enums.BillingType;
import org.example.repository.ReservationRepository;
import org.example.repository.VmRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class AzureReservationService {

    private final ReservationsManager reservationsManager;
    private final ReservationRepository reservationRepository;
    private final VmRepository vmRepository;

    public List<ReservationDto> getAllReservations() {
        List<ReservationDto> reservations = new ArrayList<>();

        try {
            Iterable<ReservationOrderResponse> reservationOrders = reservationsManager.reservationOrders().list();

            for (ReservationOrderResponse order : reservationOrders) {
                String orderId = extractLastSegment(order.id());
                Iterable<ReservationResponse> fullReservations = reservationsManager.reservations().list(orderId);

                for (ReservationResponse reservation : fullReservations) {
                    String vmType = "Unknown";
                    if (reservation.sku() != null && reservation.sku().name() != null) {
                        vmType = reservation.sku().name();
                        if (vmType.startsWith("Standard_")) {
                            vmType = vmType.substring(9);
                        }
                        vmType = vmType.replace("_", " ");
                    }

                    ReservationDto dto = ReservationDto.builder()
                            .reservationId(reservation.id())
                            .reservationOrderId(order.id())
                            .displayName(order.displayName())
                            .vmType(vmType)
                            .term(order.term() != null ? order.term().toString() : "")
                            .provisioningState(order.provisioningState() != null ? order.provisioningState().toString() : "")
                            .expiryDateTime(order.expiryDateTime())
                            .purchaseDateTime(order.createdDateTime())
                            .build();
                    reservations.add(dto);
                }
            }

            log.info("Retrieved {} reservations from Azure", reservations.size());
        } catch (Exception e) {
            log.error("Failed to fetch reservations: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to fetch reservations", e);
        }

        return reservations;
    }

    public List<ReservationDto> getActiveReservations() {
        return getAllReservations().stream()
                .filter(r -> "Succeeded".equals(r.getProvisioningState()))
                .filter(r -> r.getExpiryDateTime() == null || r.getExpiryDateTime().isAfter(OffsetDateTime.now()))
                .collect(Collectors.toList());
    }

    @Transactional
    public String syncActiveReservations() {
        log.info("Syncing active reservations...");

        List<ReservationDto> activeReservations = getActiveReservations();

   

        for (ReservationDto dto : activeReservations) {
            Reservation entity = Reservation.builder()
                    .reservationId(dto.getReservationId())
                    .vmType(dto.getVmType())
                    .displayName(dto.getDisplayName())
                    .purchaseDateTime(dto.getPurchaseDateTime())
                    .expiryDateTime(dto.getExpiryDateTime())
                    .syncedAt(LocalDateTime.now())
                    .build();
            reservationRepository.save(entity);
        }

        log.info("Saved {} active reservations", activeReservations.size());
        return String.format("Saved %d active reservations", activeReservations.size());
    }

    @Transactional(readOnly = true)
    public List<ReservationWithVmsDto> getActiveReservationsWithLinkedVms() {
        log.info("Fetching active reservations with linked VMs");

        
        List<Reservation> activeReservations = reservationRepository.findAllActive();

        if (activeReservations.isEmpty()) {
            log.warn("No active reservations found");
            return Collections.emptyList();
        }
        
        List<Vm> reservationVms = vmRepository.findByBillingType(BillingType.RESERVATION);

        if (reservationVms.isEmpty()) {
            log.warn("No VMs with RESERVATION billing type found");
            return Collections.emptyList();
        }

        Map<String, List<Vm>> vmsByType = reservationVms.stream()
                .collect(Collectors.groupingBy(Vm::getVmType));

        List<ReservationWithVmsDto> result = new ArrayList<>();

        for (Reservation reservation : activeReservations) {
            String vmType = reservation.getVmType();
            List<Vm> matchingVms = vmsByType.getOrDefault(vmType, Collections.emptyList());

            List<ReservationWithVmsDto.LinkedVmDto> linkedVms = matchingVms.stream()
                    .map(vm -> ReservationWithVmsDto.LinkedVmDto.builder()
                            .vmName(vm.getName())
                            .build())
                    .collect(Collectors.toList());

            ReservationWithVmsDto dto = ReservationWithVmsDto.builder()
                    .displayName(reservation.getDisplayName())
                    .vmType(vmType)
                    .purchaseDateTime(reservation.getPurchaseDateTime())
                    .expiryDateTime(reservation.getExpiryDateTime())
                    .linkedVms(linkedVms)
                    .build();

            result.add(dto);

            log.info("Reservation '{}' (type: {}) linked to {} VMs",
                    reservation.getDisplayName(), vmType, linkedVms.size());
        }

        log.info("Returning {} active reservations with linked VMs", result.size());
        return result;
    }

    private String extractLastSegment(String armId) {
        if (armId == null || armId.isBlank()) return "";
        String[] parts = armId.split("/");
        return parts[parts.length - 1];
    }
}