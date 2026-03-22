package org.example.dto;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserPayload {
    private Long id;
    private String email;
    private String role;
}
