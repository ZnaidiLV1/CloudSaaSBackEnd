package org.example.service;

import lombok.RequiredArgsConstructor;
import org.example.dto.*;
import org.example.entity.User;
import org.example.enums.Role;
import org.example.repository.UserRepository;
import org.example.security.JwtUtil;
import org.springframework.security.authentication.*;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    public AuthPayload login(String email , String password) {
        try{
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(email,password)
            );
        }
        catch (AuthenticationException e)
        {
            throw new RuntimeException("invalid email or password");
        }
        User user=userRepository.findByEmail(email)
                .orElseThrow( () -> new RuntimeException("User not found"));

        String otp = String.format("%06d", new Random().nextInt(999999));

        user.setOtpCode(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(5));
        userRepository.save(user);

        emailService.sendOtp(user.getEmail(), otp);
        return new AuthPayload(null,null,email,"otp sent to"+email);

    }

    public AuthPayload verifyOtp(String email,String otp){
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));

        if (user.getOtpCode() == null) {
            throw new RuntimeException("No OTP requested for this account");
        }

        if(LocalDateTime.now().isAfter(user.getOtpExpiry()))
        {
            user.setOtpCode(null);
            user.setOtpExpiry(null);
            userRepository.save(user);
            throw new RuntimeException("OTP expired , login again");
        }

        if(!user.getOtpCode().equals(otp))
        {
            throw new RuntimeException("Invalid OTP");
        }

        String token=jwtUtil.generateToken(user);

        return new AuthPayload(token,user.getRole().name(),user.getEmail(),"login successfully");
    }

    public CreationPayload createUser(String email,String role){
        if(userRepository.existsByEmail(email)){
            throw new RuntimeException("Email already exists");
        }
        Role userRole;
        try{
            userRole=Role.valueOf(role.toUpperCase());
        }catch (IllegalArgumentException e) {
            throw new RuntimeException("Invalid role: " + role +
                    ". Valid roles: SUPER_ADMIN, MANAGER, TECHNICAL, FINANCE");
        }

        String tempPassword = java.util.UUID.randomUUID().toString().replaceAll("[^A-Za-z]", "").substring(0, 6);

        User user=User.builder()
                .email(email)
                .role(userRole)
                .password(passwordEncoder.encode(tempPassword))
                .build();
        userRepository.save(user);

        emailService.sendUserCredentials(email,tempPassword);

        return new CreationPayload(email,"password sent to : "+email);
    }

    public List<UserPayload> getAllUsers(){
        return userRepository.findAll().stream()
                .map(u->new UserPayload(u.getId(),u.getEmail(),u.getRole().name()))
                .collect(Collectors.toList());
    }


}