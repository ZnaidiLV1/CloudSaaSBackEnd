package org.example.ai.dto.openRouter;

import lombok.Data;
import java.util.List;

@Data
public class OpenRouterRequest {
    private String model;
    private List<Message> messages;
    private double temperature;
    private int max_tokens;

    @Data
    public static class Message {
        private String role;
        private String content;

        public Message(String role, String content) {
            this.role = role;
            this.content = content;
        }
    }
}