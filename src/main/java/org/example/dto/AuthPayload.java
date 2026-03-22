package org.example.dto;

import lombok.*;

@Data
@AllArgsConstructor
public class AuthPayload {
    private String token;
    private String role;
    private String email;
    private String message;
}