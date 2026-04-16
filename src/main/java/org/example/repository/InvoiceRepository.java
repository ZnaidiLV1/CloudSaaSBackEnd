package org.example.repository;

import org.example.entity.Invoice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface InvoiceRepository extends JpaRepository<Invoice, Long> {
    Optional<Invoice> findByInvoiceId(String invoiceId);
    @Query("SELECT MAX(i.invoiceDate) FROM Invoice i")
    LocalDateTime findNewestInvoiceDate();

    @Query("SELECT i FROM Invoice i WHERE i.invoiceDate BETWEEN :start AND :end ORDER BY i.invoiceDate DESC")
    List<Invoice> findInvoicesBetweenDates(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);

    @Query("SELECT MIN(i.invoiceDate) FROM Invoice i")
    LocalDateTime findOldestInvoiceDate();

    @Query("SELECT i FROM Invoice i WHERE i.billingPeriodStart BETWEEN :start AND :end ORDER BY i.billingPeriodStart ASC")
    List<Invoice> findInvoicesByBillingPeriodStartBetween(@Param("start") LocalDateTime start, @Param("end") LocalDateTime end);
}