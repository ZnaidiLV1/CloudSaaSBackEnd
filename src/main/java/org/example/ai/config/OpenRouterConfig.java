package org.example.ai.config;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
@Getter
public class OpenRouterConfig {

    @Value("${openrouter.base.url}") private String baseUrl;
    @Value("${openrouter.api.key}") private String apiKey;
    @Value("${openrouter.model.id}") private String modelId;
    @Value("${openrouter.max.tokens}") private int maxTokens;
    @Value("${openrouter.temperature}") private double temperature;

    @Bean
    public WebClient openRouterWebClient() {
        return WebClient.builder()
                .baseUrl(baseUrl)
                .defaultHeader("Authorization", "Bearer " + apiKey)
                .defaultHeader("Content-Type", "application/json")
                .build();
    }
}