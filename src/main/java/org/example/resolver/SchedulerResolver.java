package org.example.resolver;

import lombok.RequiredArgsConstructor;
import org.example.service.SchedulerService;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;

import java.util.Map;

@Controller
@RequiredArgsConstructor
public class SchedulerResolver {

    private final SchedulerService schedulerService;

    @MutationMapping
    @PreAuthorize("hasAnyRole('SUPER_ADMIN', 'MANAGER')")
    public String updateScheduler(@Argument String task, @Argument String cronExpression) {
        return schedulerService.updateSchedule(task, cronExpression);
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public Map<String, Map<String, Object>> getAllSchedules() {
        return schedulerService.getAllSchedules();
    }
}