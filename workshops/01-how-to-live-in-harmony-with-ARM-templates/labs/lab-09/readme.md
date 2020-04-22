# lab-09 - refactoring: introduce parameters file

Sending parameters to the deployment command works fine but it's noisy and not really practical. Instead, we can collect all parameters into parameters json file and provide this file as a parameter for the deployment script.

## Estimated completion time - 10 min

## Useful links

* [Parameters in Azure Resource Manager templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-parameters)
* [Create Resource Manager parameter file](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/parameter-files)

## Task #1 (optional) - copy files from `lab-08` folder to `lab-09` folder

## Task #2 - create parameters file for nsg ARM template

Create `parameters.json` file at the `01-nsg` folder.
Add the following parameters to this file.

Hint 1: Try to use `armp!` and `arm-param` snippets of `Azure Resource Manager (ARM) Tools`.
Hint 2: VS Code can autogenerate parameter file for you. Open your `template.json` file, press **F1** and from the menu select "Azure Resource Manager Tools: Select/Create Parameter file...". Choose "new" and "all parameters". Choose a name for your file and fill in missing values.

| Parameter  | Value |
|---|---|
| environment | dev |
| location | westeurope |

## Validate ARM template

```bash
az deployment group validate -g iac-dev-rg --template-file template.json --parameters @parameters.json -o table
```

Note that this time we use `parameters.json` as a value for `--parameters` attribute.

## Deploy ARM template

```bash
az deployment group create -g iac-dev-rg --template-file template.json --parameters @parameters.json -o table
```

Note that this time we use `parameters.json` as a value for `--parameters` attribute.

## Task #3 - change `validate.sh` and `deploy.sh` file

Apply corresponding changes to the `validate.sh` and `deploy.sh` files.

Validate and deploy by using `validate.sh` and `deploy.sh` scripts.

## Task #4 - create parameters file for vnet ARM template

Create `parameters.json` file at the `02-vnet` folder.
Add the following parameters to this file.

Hint 1: Try to use `armp!` and `arm-param` snippets of `Azure Resource Manager (ARM) Tools`.
Hint 2: VS Code can autogenerate parameter file for you. Open your `template.json` file, press **F1** and from the menu select "Azure Resource Manager Tools: Select/Create Parameter file...". Choose "new" and "all parameters". Choose a name for your file and fill in missing values.

| Parameter  | Value |
|---|---|
| environment | dev |
| location | westeurope |
| vnetAddressPrefix | 10.112.0.0/16 |
| agwSubnetAddressPrefix | 10.112.16.128/25 |
| aksSubnetAddressPrefix | 10.112.0.0/20 |

## Validate ARM template

```bash
az deployment group validate -g iac-dev-rg --template-file template.json --parameters @parameters.json -o table
```

Note that this time we use `parameters.json` as a value for `--parameters` attribute.

## Deploy ARM template

```bash
az deployment group create -g iac-dev-rg --template-file template.json --parameters @parameters.json -o table
```

Note that this time we use `parameters.json` as a value for `--parameters` attribute.

## Task #5 - change `validate.sh` and `deploy.sh` file

Apply corresponding changes to the `validate.sh` and `deploy.sh` files.

Validate and deploy by using `validate.sh` and `deploy.sh` scripts.

## Checkpoints

Make sure that you still can validate and deploy by using master validate and deploy scripts.

## Next

[Go to lab-10](../lab-10/readme.md)
