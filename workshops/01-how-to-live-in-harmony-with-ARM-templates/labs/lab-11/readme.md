# lab-11 - provision production environment

Now it's time to provision production environment.
Here is the production environment configuration

| Parameter  | Value |
|---|---|
| environment | prod |
| location | northeurope |
| vnetAddressPrefix | 10.100.0.0/16 |
| agwSubnetAddressPrefix | 10.100.16.128/25 |
| aksSubnetAddressPrefix | 10.100.0.0/20 |

## Task #1 - add parameters file for production environment for nsg ARM template

Create `parameters-prod.json` file with the following parameters

| Parameter  | Value |
|---|---|
| environment | prod |
| location | northeurope |
| agwSubnetAddressPrefix | 10.100.16.128/25 |
| aksSubnetAddressPrefix | 10.100.0.0/20 |

## Task 2 - add parameters file for production environment for vnet ARM template

Create `parameters-prod.json` file with the following parameters

| Parameter  | Value |
|---|---|
| environment | prod |
| location | northeurope |
| vnetAddressPrefix | 10.100.0.0/16 |
| agwSubnetAddressPrefix | 10.100.16.128/25 |
| aksSubnetAddressPrefix | 10.100.0.0/20 |

## Task #3 - deploy production environment

Validate production template with master validation script

```bash
./validate.sh prod
```

Deploy production template with master deploy script

```bash
./deploy.sh prod
```

## Checkpoints

Navigate to the portal and check that all 3 resources are created under `iac-prod-rg`.
