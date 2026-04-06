package org.example.resolver;

import com.azure.resourcemanager.billing.models.Reservation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.dto.ReservationDto;
import org.example.service.AzureReservationService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
@RequiredArgsConstructor
@Slf4j
public class ReservationResolver {

    private final AzureReservationService reservationService;

    @MutationMapping
    public String syncActiveReservations() {
        return reservationService.syncActiveReservations();
    }
}
