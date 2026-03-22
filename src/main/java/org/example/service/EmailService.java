package org.example.service;

import lombok.RequiredArgsConstructor;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender mailSender;

    public void sendOtp(String toEmail,String otp){
        SimpleMailMessage message=new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("CloudSaaS - Your verification code");
        message.setText(
                "Your verification code is: " + otp + "\n\n" +
                        "This code expires in 5 minutes.\n" +
                        "If you did not request this, ignore this email."
        );
        mailSender.send(message);
    }
    public void sendUserCredentials(String toEmail,String password){
        SimpleMailMessage message=new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("CloudSaaS - Your account credentials");
        message.setText(
                "Your password is: " + password + "\n\n" +
                        "You can change it later.\n"
        );
        mailSender.send(message);
    }
}
