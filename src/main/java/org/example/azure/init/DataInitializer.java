package org.example.azure.init;

import lombok.RequiredArgsConstructor;
import org.example.azure.entity.User;
import org.example.azure.enums.Role;
import org.example.azure.repository.UserRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements ApplicationRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Value("${app.superadmin.email}")
    private String superAdminEmail;

    @Value("${app.superadmin.password}")
    private String superAdminPassword;

    @Override
    public void run(ApplicationArguments args) {
        if (!userRepository.existsByEmail(superAdminEmail)) {
            User superAdmin = User.builder()
                    .email(superAdminEmail)
                    .password(passwordEncoder.encode(superAdminPassword))
                    .role(Role.SUPER_ADMIN)
                    .build();
            userRepository.save(superAdmin);
            System.out.println("✅ Super Admin created: " + superAdminEmail);
        } else {
            System.out.println("ℹ️ Super Admin already exists, skipping.");
        }
    }
}