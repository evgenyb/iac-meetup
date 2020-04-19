# Naming conventions

Let's follow the following naming conventions for some of the resources we will be working with:

| Resource  | Name Convention |
|---|---|
| ARM template file | template.json |
| ARM template parameters file | parameters.json |
| Environment specific ARM template parameters file | parameters-{environment}.json |
| Validation script | validate.sh or validate.ps1 |
| Deployment script | deploy.sh or deploy.ps1 |
| Deployment name | {type}-{environment}-yyyyMMdd-hhmmss |
| Resource Group | iac-{environment}-rg |
| Key Vault | iac-{environment}-kv (max 24 char) |
| VNet | iac-{environment}-vnet |
| Subnet | aks-net, agw-v2-net |
| NSG | iac-aks-{environment}-nsg, iac-agw-v2-{environment}-nsg |
| Storage accounts | iacdiagnostics{environment}sa |
