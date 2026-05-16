package org.example.ai.client;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.config.OpenRouterConfig;
import org.example.ai.dto.openRouter.OpenRouterRequest;
import org.example.ai.dto.openRouter.OpenRouterResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class OpenRouterClient {

    private final WebClient openRouterWebClient;
    private final OpenRouterConfig config;

    public String sendMessage(String userMessage) {
        OpenRouterRequest request = new OpenRouterRequest();
        request.setModel(config.getModelId());
        request.setTemperature(config.getTemperature());
        request.setMax_tokens(config.getMaxTokens());
        request.setMessages(List.of(
                new OpenRouterRequest.Message("user", userMessage)
        ));

        log.info("=== OPENROUTER CLIENT DEBUG ===");
        log.info("Base URL: {}", config.getBaseUrl());
        log.info("Model ID: {}", config.getModelId());
        log.info("Max Tokens: {}", config.getMaxTokens());
        log.info("Temperature: {}", config.getTemperature());
        log.info("API Key (first 10 chars): {}", config.getApiKey().substring(0, Math.min(10, config.getApiKey().length())));
        log.info("Request payload size: {} chars", userMessage.length());
        log.info("=== END DEBUG ===");

        try {
            long startTime = System.currentTimeMillis();
            log.info("Sending request to OpenRouter API at: {}/chat/completions", config.getBaseUrl());

            OpenRouterResponse response = openRouterWebClient.post()
                    .uri("/chat/completions")
                    .bodyValue(request)
                    .retrieve()
                    .onStatus(status -> status.is4xxClientError() || status.is5xxServerError(),
                            clientResponse -> {
                                log.error("API Error Status: {}", clientResponse.statusCode());
                                return clientResponse.bodyToMono(String.class)
                                        .flatMap(errorBody -> {
                                            log.error("API Error Body: {}", errorBody);
                                            return Mono.error(new RuntimeException("API Error: " + clientResponse.statusCode() + " - " + errorBody));
                                        });
                            })
                    .bodyToMono(OpenRouterResponse.class)
                    .doOnSubscribe(sub -> log.info("Request subscribed"))
                    .doOnNext(resp -> log.info("Response received successfully"))
                    .doOnError(err -> log.error("Error during request: {}", err.getMessage()))
                    .block();

            long endTime = System.currentTimeMillis();
            log.info("Request completed in {} ms", (endTime - startTime));

            if (response != null && response.getChoices() != null && !response.getChoices().isEmpty()) {
                String content = response.getChoices().get(0).getMessage().getContent();
                log.info("AI response received, length: {}", content != null ? content.length() : 0);
                return content;
            }
            log.warn("Empty response from OpenRouter - response: {}", response);
            return "No response from AI";
        } catch (Exception e) {
            log.error("OpenRouter error: {}", e.getMessage(), e);
            return "Error: " + e.getMessage();
        }
    }
}