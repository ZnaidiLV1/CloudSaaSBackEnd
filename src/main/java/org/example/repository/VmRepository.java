package org.example.repository;

import org.example.entity.Vm;
import org.example.enums.BillingType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

public interface VmRepository extends JpaRepository<Vm, Long> {

    Optional<Vm> findByAzureVmId(String azureVmId);

    @Query("SELECT DISTINCT v FROM Vm v JOIN v.tags t " +
            "WHERE t.key = 'Product' AND t.value = :product")
    List<Vm> findByProduct(@Param("product") String product);

    List<Vm> findByResourceGroup(String resourceGroup);

    @Query("SELECT DISTINCT v FROM Vm v JOIN v.tags t " +
            "WHERE t.key = :key AND t.value = :value")
    List<Vm> findByTag(@Param("key") String key,
                       @Param("value") String value);

    @Query("SELECT DISTINCT t.value FROM Vm v JOIN v.tags t " +
            "WHERE t.key = 'Product'")
    List<String> findAllProducts();
    List<Vm> findByVmType(String vmType);

    @Query("SELECT v FROM Vm v WHERE v.status = 'Running'")
    List<Vm> findAllRunningVms();

    @Modifying
    @Transactional
    @Query("UPDATE Vm v SET v.billingType = :billingType WHERE v.id = :vmId")
    void updateBillingTypeEnum(@Param("vmId") Long vmId, @Param("billingType") BillingType billingType);



}