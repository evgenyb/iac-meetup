#!/usr/bin/env bash
#
# Usage
# ./deploy-blue.sh dev blue
#

environment=$1
slot=$2

timestamp=`date "+%Y%m%d-%H%M%S"`
baseResourceGroupName="iac-$environment-rg"
resourceGroupName="iac-$environment-$slot-rg"
parametersFile="parameters-${environment}-$slot.json"
apiAppserviceName="iac-${environment}-$slot-api-appservice"
vnetName="iac-${environment}-$slot-vnet"
cosmosDbName="iac-$environment-cosmosdb"
vstsSpnName="iac-$environment-spn"

echo -e "Create new resource group ${resourceGroupName}"
az group create -l "westeurope" -n ${resourceGroupName} --tags "Owner=team-iac" 1> /dev/null

echo -e "Deploying vnet to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/01-vnet/template.json --parameters ../arm/01-vnet/${parametersFile} -n "vnet-$environment-${timestamp}"

echo -e "Deploying Service Plan to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/05-service-plan/template.json --parameters ../arm/05-service-plan/${parametersFile} -n "service-plan-$environment-${timestamp}"

echo -e "Deploying webapp app to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/06-appservice-app/template.json --parameters ../arm/06-appservice-app/${parametersFile} -n "appservice-app-$environment-${timestamp}"

echo -e "Deploying webapp api $apiAppserviceName to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/07-appservice-api/template.json --parameters ../arm/07-appservice-api/${parametersFile} -n "appservice-api-$environment-${timestamp}"

echo -e "Setting up vnet integration with ${vnetName}"
az webapp vnet-integration add -g ${resourceGroupName} -n ${apiAppserviceName} --vnet ${vnetName} --subnet integration-net

echo -e "Get connection string for cosmosdb ${cosmosDbName}"
connectionString=$(az cosmosdb keys list --name ${cosmosDbName} --resource-group ${baseResourceGroupName} --type connection-strings --query "connectionStrings[0].connectionString" | jq . -r)

echo -e "Add  cosmosdb connection string to ${apiAppserviceName}"
az webapp config connection-string set -g ${resourceGroupName} -n ${apiAppserviceName} -t DocDb --settings DocDb=${connectionString} 1> /dev/null

echo -e "Add vnet to cosmosdb"
subnetid=$(az network vnet subnet show --vnet-name iac-${environment}-${slot}-vnet -n integration-net -g ${resourceGroupName} --query id | jq . -r)
az cosmosdb network-rule add --subnet $subnetid --name ${cosmosDbName} --resource-group ${baseResourceGroupName}

echo -e "Deploying AGW  ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/08-agw-v2/template.json --parameters ../arm/08-agw-v2/${parametersFile} -n "agw-$environment-${timestamp}"

