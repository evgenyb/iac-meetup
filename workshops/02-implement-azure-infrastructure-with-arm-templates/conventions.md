# Conventions

## Folder structure

Let's use the following naming structure:

```txt
infrastructure
    arm
        01-storage-account
        02-front-door
src
    web
```

Where `infrastructure` folder contains arm templates and deployment scripts and `src` folder contains source code of our webapp.

## Naming convention

Let's follow the following conventions:

| Resource  | Name Convention |
|---|---|
| ARM template file | template.json |
| ARM template parameters file | parameters.json |
| Environment specific ARM template parameters file | parameters-{environment}.json |
| Validation script | validate.sh |
| Deployment script | deploy.sh |
| Deployment name | {type}-yyyyMMdd-hhmmss |
| Environment specific Resource Group | iac-ws2-{environment}-rg |
| Base Resource Group | iac-ws2-rg |
| Storage accounts | iacws2{user}{environment}sa |
| Front Door | iac-ws2-{user}-fd |
| Azure pipeline YML file | {name}-pipeline.yaml |

where

* `environment` - can be either `blue` or `green`
* `user` - something that will differentiate you from other participants. Storage account and Front Door products register names in DNS, therefore the name should be globally unique
