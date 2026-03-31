package org.example.config;

import com.azure.core.management.AzureEnvironment;
import com.azure.core.management.profile.AzureProfile;
import com.azure.identity.ClientSecretCredential;
import com.azure.identity.ClientSecretCredentialBuilder;
import com.azure.resourcemanager.AzureResourceManager;
import com.azure.resourcemanager.costmanagement.CostManagementManager;
import com.azure.monitor.query.MetricsQueryClient;
import com.azure.monitor.query.MetricsQueryClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AzureConfig {

    @Value("${azure.client-id}")
    private String clientId;

    @Value("${azure.tenant-id}")
    private String tenantId;

    @Value("${azure.client-secret}")
    private String clientSecret;

    @Value("${azure.subscription-id}")
    private String subscriptionId;

    @Bean
    public ClientSecretCredential clientSecretCredential() {
        return new ClientSecretCredentialBuilder()
                .clientId(clientId)
                .tenantId(tenantId)
                .clientSecret(clientSecret)
                .build();
    }

    @Bean
    public AzureProfile azureProfile() {
        return new AzureProfile(tenantId, subscriptionId,
                AzureEnvironment.AZURE);
    }

    @Bean
    public AzureResourceManager azureResourceManager(
            ClientSecretCredential credential,
            AzureProfile profile) {
        return AzureResourceManager
                .authenticate(credential, profile)
                .withDefaultSubscription();
    }

    @Bean
    public MetricsQueryClient metricsQueryClient(
            ClientSecretCredential credential) {
        return new MetricsQueryClientBuilder()
                .credential(credential)
                .buildClient();
    }

    @Bean
    public CostManagementManager costManagementManager(
            ClientSecretCredential credential,
            AzureProfile profile) {
        return CostManagementManager
                .authenticate(credential, profile);
    }
}