package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailService {
    private final JavaMailSender mailSender;

    public void sendOtp(String toEmail, String otp) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(toEmail);
            message.setSubject("CloudSaaS - Your verification code");
            message.setText(
                    "Your verification code is: " + otp + "\n\n" +
                            "This code expires in 5 minutes.\n" +
                            "If you did not request this, ignore this email."
            );
            mailSender.send(message);
            log.info("OTP email sent to {}", toEmail);
        } catch (Exception e) {
            log.error("Failed to send OTP email to {}: {}", toEmail, e.getMessage());
        }
    }

    public void sendUserCredentials(String toEmail, String password) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(toEmail);
            message.setSubject("CloudSaaS - Your account credentials");
            message.setText(
                    "Your password is: " + password + "\n\n" +
                            "You can change it later.\n"
            );
            mailSender.send(message);
            log.info("Credentials email sent to {}", toEmail);
        } catch (Exception e) {
            log.error("Failed to send credentials email to {}: {}", toEmail, e.getMessage());
        }
    }

    public void sendPasswordChangeOtp(String email, String otp) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(email);
            message.setSubject("CloudSaaS - Password Change Verification");
            message.setText(
                    "You requested a password change.\n\n" +
                            "Your verification code is: " + otp + "\n\n" +
                            "This code expires in 5 minutes.\n" +
                            "If you did not request this, your account may be compromised."
            );
            mailSender.send(message);
            log.info("Password change OTP sent to {}", email);
        } catch (Exception e) {
            log.error("Failed to send password change OTP to {}: {}", email, e.getMessage());
        }
    }

    public void sendForgotPasswordOtp(String toEmail, String otp) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(toEmail);
            message.setSubject("CloudSaaS - Password Reset");
            message.setText(
                    "You requested a password reset.\n\n" +
                            "Your reset code is: " + otp + "\n\n" +
                            "This code expires in 5 minutes.\n" +
                            "If you did not request this, ignore this email."
            );
            mailSender.send(message);
            log.info("Forgot password OTP sent to {}", toEmail);
        } catch (Exception e) {
            log.error("Failed to send forgot password OTP to {}: {}", toEmail, e.getMessage());
        }
    }
}
