package org.example.repository;

import org.example.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;
import java.time.OffsetDateTime;
import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, String> {

    List<Reservation> findByExpiryDateTimeAfter(OffsetDateTime now);

    @Modifying
    @Transactional
    @Query("DELETE FROM Reservation r WHERE r.expiryDateTime < CURRENT_TIMESTAMP")
    void deleteExpired();
}