package org.example.dto;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CreationPayload {
    private String email;
    private String message;
}
