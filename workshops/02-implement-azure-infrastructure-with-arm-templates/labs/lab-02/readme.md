# Lab-02 - create storage account ARM template

The goals for this lab are:

* implement ARM template for storage account with `Standard_LRS` sku
* implement parameters file for `blue` and `green` environments

## Estimated completion time - x min

## Useful links

* [Storage account overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)
* [Static website hosting in Azure Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website)
* [Standard Storage Account 101](https://github.com/Azure/azure-quickstart-templates/tree/master/101-storage-account-create)
* [Microsoft.Storage storageAccounts template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.storage/2019-06-01/storageaccounts)
* [az storage account](https://docs.microsoft.com/en-us/cli/azure/storage/account?view=azure-cli-latest)

## Task #1 - create folder structure for arm templates

Create the following folder structure under your git repository:

```txt
infrastructure
    arm
        01-storage-account
```

## Task #2 - implement storage account ARM template

Create `template.json` file and implement storage account ARM template with the following requirements:

* sku should be `Standard_LRS`
* it should use the following parameters

| Parameter name  | Type | Default value|
|---|---|---|
| location | string | westeurope |
| storageAccountName | string | - |
| release | string | local |

* storage account name value should be set from the parameter `storageAccountName`
* storage account should be tagged with with following tags

| Tag name  | Value |
|---|---|
| owner | team-platform |
| release | should use value from `release` parameter |

## Task #3 - create 2 parameter files

Create 2 parameter files called `parameters-blue.json` and `parameters-green.json` with `location` parameter configured with the following values:

| Environment  | location value |
|---|---|
| blue | westeurope |
| green | northeurope |

## Task #4 - create validate script

Create `validate.sh` script.
Note that `storageAccountName` should follow [naming convention](../../conventions.md) and should be composed as `iacws2{user}{slot}sa`.
We want to use the same script to validate template for both `blue` and `green` environments, therefore environment will be sent as an input parameter.

```bash
#!/usr/bin/env bash
slot=$1
storageAccountName="iacws2evg${slot}as"

az deployment group validate -g iac-ws2-${slot}-rg \
        --template-file template.json \
        --parameters @parameters-${slot}.json \
        --parameters storageAccountName=${storageAccountName} -o table
```

Validate your template:

```bash
./validate.sh blue
./validate.sh green
```

## Task #5 - commit and push your changes

```bash
git add .
git comment -m "Finish lab-02"
git push
```

## Checkpoint

You should have the following files and folders structure.

```txt
infrastructure
    arm
        01-storage-account
            template.json
            parameters-blue.json
            parameters-green.json
```

Your template should be valid for both environments.

You should have no changes at your repository

```bash
git status
...
nothing to commit, working tree clean
```

## Next

[Go to lab-03](../lab-03/readme.md)