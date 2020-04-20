# lab-08 - refactoring: introduce parameters

Parameters are the powerful way to make your ARM templates re-usable. If your infrastructure looks the same between several environments, then you can implement one template, identify the differences between environments, implement them as parameters and specify them at the deployment time.

If we look at our example, the following values are candidates to be defined as parameters:

* environment
* location
* aks subnet address prefix
* agw subnet address prefix
* vnet address prefix

## Task #1 - introduce parameters to nsg ARM template

Add the following parameters to the nsg ARM template
| Parameter  | Type | Default value | Parameter value (used by deployment script)|
|---|---|---|---|
| environment | string | | dev|
| location | string | westeurope | westeurope|
| agwSubnetAddressPrefix | securestring | | 10.112.16.128/25 |
| aksSubnetAddressPrefix | securestring | | 10.112.0.0/20 |

Use `[parameters('<parameter-name>')]` construct in the template.

### Validate template (script is not completed)

```bash
az group deployment validate -g iac-dev-rg --template-file template.json --parameters location=westeurope --parameters environment=dev ...
```

Note, that we need to use `--parameters` for each parameter.

### Deploy template (script is not completed)

```bash
az group deployment create -g iac-dev-rg --template-file template.json --parameters location=westeurope --parameters environment=dev ...
```

Note, that we need to use `--parameters` for each parameter.

## Task #2 - change `validate.sh` and `deploy.sh` file

Apply corresponding changes to the `validate.sh` and `deploy.sh` files.

Validate and deploy by using `validate.sh` and `deploy.sh` scripts.

## Task #3 - introduce parameters to vnet ARM template

Add the following parameters to the nsg ARM template
| Parameter  | Type | Default value | Parameter value (used by deployment script)|
|---|---|---|---|
| environment | string | | dev|
| location | string | westeurope | westeurope|
| vnetAddressPrefix | securestring | | 110.112.0.0/16 |
| agwSubnetAddressPrefix | securestring | | 10.112.16.128/25 |
| aksSubnetAddressPrefix | securestring | | 10.112.0.0/20 |

Use `[parameters('<parameter-name>')]` construct in the template.

### Validate template (script is not completed)

```bash
az group deployment validate -g iac-dev-rg --template-file template.json --parameters location=westeurope --parameters environment=dev ...
```

Note, that we need to use `--parameters` for each parameter.

### Deploy template (script is not completed)

```bash
az group deployment create -g iac-dev-rg --template-file template.json --parameters location=westeurope --parameters environment=dev ...
```

Note, that we need to use `--parameters` for each parameter.

## Task #4 - change `validate.sh` and `deploy.sh` file

Apply corresponding changes to the `validate.sh` and `deploy.sh` files.

Validate and deploy by using `validate.sh` and `deploy.sh` scripts.

## Checkpoints

Make sure that you still can validate and deploy by using master validate and deploy scripts.

## Next

[Go to lab-09](../lab-09/readme.md)
