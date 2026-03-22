package org.example.dto;

import lombok.Data;

@Data
public class LoginInput {
    private String email;
    private String password;
}