package org.example.service;

import lombok.RequiredArgsConstructor;
import org.example.dto.*;
import org.example.entity.BlacklistedToken;
import org.example.entity.User;
import org.example.enums.Role;
import org.example.repository.BlacklistedTokenRepository;
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
    private final BlacklistedTokenRepository blacklistedTokenRepository;

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

    public AuthPayload requestPasswordChange(String email,String currentPassword){
        User user=userRepository.findByEmail(email)
                .orElseThrow(()->new RuntimeException("User does not exist"));

        if (currentPassword == null || currentPassword.isBlank()) {
            throw new RuntimeException("Current password is required");
        }

        if(!passwordEncoder.matches(currentPassword,user.getPassword())){
            throw new RuntimeException("Current password is incorrect");
        }

        String otp = String.format("%06d", new Random().nextInt(999999));
        user.setOtpCode(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(5));
        userRepository.save(user);

        emailService.sendPasswordChangeOtp(email,otp);
        return new AuthPayload(null,null,email,"OTP sent to " + email + ". Use it to confirm your password change.");
    }

    public AuthPayload confirmPasswordChange(String otp,String email,String newPassword){
        User user=userRepository.findByEmail(email)
                .orElseThrow(()->new RuntimeException("User not found"));

        if(user.getOtpCode()==null){
            throw new RuntimeException("No password change was requested");
        }

        if(LocalDateTime.now().isAfter(user.getOtpExpiry())){
            user.setOtpCode(null);
            user.setOtpExpiry(null);
            userRepository.save(user);
            throw new RuntimeException("OTP expired , try again");
        }

        if(!user.getOtpCode().equals(otp)){
            throw new RuntimeException("Wrong Code");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setOtpCode(null);
        user.setOtpExpiry(null);
        userRepository.save(user);

        return new AuthPayload(null,null,email,"Password changed successfully");
    }

    public AuthPayload logout(String token) {
        BlacklistedToken blacklisted = BlacklistedToken.builder()
                .token(token)
                .blacklistedAt(LocalDateTime.now())
                .build();

        blacklistedTokenRepository.save(blacklisted);

        return new AuthPayload(null, null, null, "Logged out successfully");
    }

    public AuthPayload forgotPassword(String email) {

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("No account found with this email"));

        String otp = String.format("%06d", new Random().nextInt(999999));
        user.setOtpCode(otp);
        user.setOtpExpiry(LocalDateTime.now().plusMinutes(5));
        userRepository.save(user);

        emailService.sendForgotPasswordOtp(email, otp);

        return new AuthPayload(null, null, email, "Password reset code sent to " + email);
    }

    public AuthPayload resetPassword(String email, String otp, String newPassword) {

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("No account found with this email"));

        if (user.getOtpCode() == null) {
            throw new RuntimeException("No password reset was requested for this account");
        }

        if (LocalDateTime.now().isAfter(user.getOtpExpiry())) {
            user.setOtpCode(null);
            user.setOtpExpiry(null);
            userRepository.save(user);
            throw new RuntimeException("Reset code has expired, please request again");
        }

        if (!user.getOtpCode().equals(otp)) {
            throw new RuntimeException("Invalid reset code");
        }

        if (newPassword.length() < 8) {
            throw new RuntimeException("Password must be at least 8 characters");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setOtpCode(null);
        user.setOtpExpiry(null);
        userRepository.save(user);

        return new AuthPayload(null, null, email, "Password reset successfully. You can now login.");
    }


}