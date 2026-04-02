package org.example.repository;


import org.example.entity.MonthlyCost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface MonthlyCostRepository extends JpaRepository<MonthlyCost, Long> {

    @Modifying
    @Transactional
    @Query("DELETE FROM MonthlyCost c WHERE c.month = :month AND c.year = :year")
    void deleteByMonthAndYear(@Param("month") Integer month, @Param("year") Integer year);

    @Query("SELECT c.serviceName, SUM(c.cost) as totalCost " +
            "FROM MonthlyCost c " +
            "WHERE c.month = :month AND c.year = :year " +
            "GROUP BY c.serviceName " +
            "ORDER BY totalCost DESC")
    List<Object[]> getCostByService(@Param("month") Integer month, @Param("year") Integer year);

    @Query("SELECT c.meterName, c.serviceName, c.cost " +
            "FROM MonthlyCost c " +
            "WHERE c.month = :month AND c.year = :year " +
            "ORDER BY c.cost DESC")
    List<Object[]> getAllMeters(@Param("month") Integer month, @Param("year") Integer year);

    @Query("SELECT c.meterName, c.serviceName, c.cost " +
            "FROM MonthlyCost c " +
            "WHERE c.month = :month AND c.year = :year " +
            "AND c.serviceName = :serviceName " +
            "ORDER BY c.cost DESC")
    List<Object[]> getMetersByService(@Param("month") Integer month,
                                      @Param("year") Integer year,
                                      @Param("serviceName") String serviceName);

    @Query("SELECT SUM(c.cost) FROM MonthlyCost c WHERE c.month = :month AND c.year = :year")
    BigDecimal getTotalCost(@Param("month") Integer month, @Param("year") Integer year);

    boolean existsByMonthAndYear(Integer month, Integer year);
}