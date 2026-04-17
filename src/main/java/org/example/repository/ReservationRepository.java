package org.example.repository;

import org.example.entity.Reservation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;
import java.time.OffsetDateTime;
import java.util.List;

public interface ReservationRepository extends JpaRepository<Reservation, String> {

    List<Reservation> findByExpiryDateTimeAfter(OffsetDateTime now);

    @Query("SELECT r FROM Reservation r WHERE r.expiryDateTime > :now")
    List<Reservation> findAllActive(@Param("now") OffsetDateTime now);

    @Query("SELECT r FROM Reservation r WHERE r.expiryDateTime > CURRENT_TIMESTAMP")
    List<Reservation> findAllActive();

    @Modifying
    @Query("DELETE FROM Reservation r WHERE r.expiryDateTime < CURRENT_TIMESTAMP")
    void deleteExpired();
}