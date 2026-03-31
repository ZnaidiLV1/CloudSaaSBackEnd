package org.example.scheduler;

import org.example.service.VmService;
import org.springframework.scheduling.annotation.Scheduled;

public class InfraScheduler {
    public final VmService vmService;

    public InfraScheduler(VmService vmService) {
        this.vmService = vmService;
    }

    @Scheduled(cron = "0 0 2 * * *")
    public void scheduledSync(){
        vmService.syncAzureInfrastructure();
    }
}
