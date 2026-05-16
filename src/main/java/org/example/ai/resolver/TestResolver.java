package org.example.ai.resolver;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.ai.client.OpenRouterClient;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
@Slf4j
public class TestResolver {

    private final OpenRouterClient openRouterClient;

    @QueryMapping
    public String testOpenRouter(@org.springframework.graphql.data.method.annotation.Argument String message) {
        log.info("Testing OpenRouter with message: {}", message);
        String result = openRouterClient.sendMessage(message);
        log.info("OpenRouter test result: {}", result);
        return result;
    }
}