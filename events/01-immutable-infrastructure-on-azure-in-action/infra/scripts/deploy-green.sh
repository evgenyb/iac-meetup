#!/usr/bin/env bash
#
# Usage
# ./deploy-green.sh dev
#

environment=$1
slot=green

timestamp=`date "+%Y%m%d-%H%M%S"`
baseResourceGroupName="iac-${environment}-rg"
resourceGroupName="iac-${environment}-${slot}-rg"
apimName="iac-${environment}-${slot}-apim"
storageAccountName="iac${environment}${slot}sa"
parametersFile="parameters-${environment}-${slot}.json"
azureFunctionAppName="iac-${environment}-${slot}-fapp"
cosmosDbName="iac-${environment}-cosmosdb"
location="westeurope"

echo -e "Create new resource group ${resourceGroupName}"
az group create -l "westeurope" -n ${resourceGroupName} --tags "Owner=team-iac" 1> /dev/null

echo -e "Create Storage account ${storageAccountName}"
az storage account create -n ${storageAccountName} -g ${resourceGroupName} -l ${location} --sku Standard_LRS --kind StorageV2

echo -e "Deploying azure function to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/09-function/template.json --parameters ../arm/09-function/${parametersFile} -n "azure-function-app-$environment-${timestamp}"

echo -e "Get connection string for cosmosdb ${cosmosDbName}"
connectionString=$(az cosmosdb keys list --name ${cosmosDbName} --resource-group ${baseResourceGroupName} --type connection-strings --query "connectionStrings[0].connectionString" | jq . -r)

echo -e "Add cosmosdb connection string to ${azureFunctionAppName}"
az webapp config connection-string set -g ${resourceGroupName} -n ${azureFunctionAppName} -t DocDb --settings DocDb=${connectionString} 1> /dev/null

echo -e "Create APIM instance $apimName"
az apim create --name ${apimName} -g ${resourceGroupName} -l ${location} --sku-name Consumption --publisher-email email@mydomain.com --publisher-name IaC