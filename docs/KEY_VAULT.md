# Azure Key Vault — optional pipeline integration

The resume mentions Azure Key Vault as a DevSecOps-related tool. This example **does not create a vault or write any secret**.

With a vault, Azure DevOps service connection and access configured, use `AzureKeyVault@2` in an authenticated pipeline job:

```yaml
- task: AzureKeyVault@2
  inputs:
    azureSubscription: 'YOUR-AZURE-SERVICE-CONNECTION'
    KeyVaultName: 'YOUR-EXISTING-KEYVAULT'
    SecretsFilter: 'demo-app-setting'
    RunAsPreJob: false
```

Keep the secret out of logs and Terraform outputs. Prefer OIDC + least privilege over static client secrets.
