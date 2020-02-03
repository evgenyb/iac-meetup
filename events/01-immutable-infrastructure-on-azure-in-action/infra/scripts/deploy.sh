#!/usr/bin/env bash

environment=$1
timestamp=`date "+%Y%m%d-%H%M%S"`
resourceGroupName="iac-$environment-rg"
parametersFile="parameters-${environment}.json"

echo -e "Create new resource group ${resourceGroupName}"
az group create -l "westeurope" -n ${resourceGroupName} --tags "Owner=team-iac" 1> /dev/null

echo -e "Deploying vnet to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/01-vnet/template.json --parameters ../arm/01-vnet/${parametersFile} -n "vnet-$environment-${timestamp}"

echo -e "Deploying app-insight to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/02-app-insight/template.json --parameters ../arm/02-app-insight/${parametersFile} -n "app-insight-$environment-${timestamp}"

echo -e "Deploying oms to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/03-oms/template.json --parameters ../arm/03-oms/${parametersFile} -n "oms-$environment-${timestamp}"

echo -e "Deploying cosmosdb to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/04-cosmosdb/template.json --parameters ../arm/04-cosmosdb/${parametersFile} -n "cosmos-$environment-${timestamp}"

echo -e "Deploying Service Plan to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/05-service-plan/template.json --parameters ../arm/05-service-plan/${parametersFile} -n "service-plan-$environment-${timestamp}"

echo -e "Deploying webapp app to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/06-appservice-app/template.json --parameters ../arm/06-appservice-app/${parametersFile} -n "appservice-app-$environment-${timestamp}"

apiAppserviceName="iac-$environment-api-appservice"
vnetName="iac-$environment-vnet"
cosmosDbName="iac-$environment-cosmosdb"

echo -e "Deploying webapp api $apiAppserviceName to ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/07-appservice-api/template.json --parameters ../arm/07-appservice-api/${parametersFile} -n "appservice-api-$environment-${timestamp}"

echo -e "Setting up vnet integration with ${vnetName}"
az webapp vnet-integration add -g ${resourceGroupName} -n ${apiAppserviceName} --vnet ${vnetName} --subnet integration-net

echo -e "Get connection string for cosmosdb ${cosmosDbName}"
connectionString=$(az cosmosdb keys list --name ${cosmosDbName} --resource-group ${resourceGroupName} --type connection-strings --query "connectionStrings[0].connectionString" | jq . -r)

echo -e "Add  cosmosdb connection string to ${apiAppserviceName}"
az webapp config connection-string set -g ${resourceGroupName} -n ${apiAppserviceName} -t DocDb --settings DocDb=${connectionString} 1> /dev/null

echo -e "Deploying AGW  ${resourceGroupName}"
az group deployment create -g ${resourceGroupName} --template-file ../arm/08-agw/template.json --parameters ../arm/08-agw/${parametersFile} -n "agw-$environment-${timestamp}"

az network dns record-set cname create -g domains-and-certificates -z www.mysite.com -n MyRecordSet