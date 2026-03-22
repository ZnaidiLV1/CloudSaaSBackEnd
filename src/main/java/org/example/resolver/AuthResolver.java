package org.example.resolver;

import lombok.RequiredArgsConstructor;
import org.example.dto.*;
import org.example.entity.User;
import org.example.repository.UserRepository;
import org.example.service.AuthService;
import org.springframework.graphql.data.method.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class AuthResolver {

    private final AuthService authService;
    private final UserRepository userRepository;

    @MutationMapping
    public AuthPayload login(@Argument String email ,@Argument String password){
        return authService.login(email,password);
    }

    @MutationMapping
    public AuthPayload verifyOtp(@Argument String email,@Argument String otp){
        return authService.verifyOtp(email,otp);
    }

    @MutationMapping
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public CreationPayload createUser(@Argument String email,@Argument String role){
        return authService.createUser(email,role);
    }

    @QueryMapping
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public List<UserPayload> getAllUsers() {
        return authService.getAllUsers();
    }

    @QueryMapping
    @PreAuthorize("isAuthenticated()")
    public User me() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return userRepository.findByEmail(auth.getName())
                .orElseThrow(() -> new RuntimeException("User not found"));
    }
}