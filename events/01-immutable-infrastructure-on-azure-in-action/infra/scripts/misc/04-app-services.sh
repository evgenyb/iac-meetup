#!/usr/bin/env bash

resourceGroupName="iac-initial-rg"
appServicePlanName="iac-initial-sp"
appAppserviceName="iac-initial-app-appservice"
apiAppserviceName="iac-initial-api-appservice"

echo -e "Creating app service plan $appServicePlanName"
# https://docs.microsoft.com/en-us/cli/azure/appservice/plan?view=azure-cli-latest#az-appservice-plan-create
az appservice plan create -g ${resourceGroupName} -n ${appServicePlanName}  --sku S1

echo -e "Creating web app $appAppserviceName"
# https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-create
az webapp create -g ${resourceGroupName} -p ${appServicePlanName} -n ${appAppserviceName} --runtime "aspnet|V4.7"

echo -e "Creating web app apiAppserviceName"
az webapp create -g ${resourceGroupName} -p ${appServicePlanName} -n ${apiAppserviceName} --runtime "aspnet|V4.7"
az webapp vnet-integration add -g ${resourceGroupName} -n ${apiAppserviceName} --vnet iac-initial-vnet --subnet integration-net
principalId=$(az webapp identity assign -n ${apiAppserviceName} -g ${resourceGroupName} --query principalId | jq . -r)

echo -e "Get connection string for cosmosdb"
connectionString=$(az cosmosdb keys list --name iac-initial-cosmosdb --resource-group ${resourceGroupName} --type connection-strings --query "connectionStrings[0].connectionString" | jq . -r)
echo -e "Set connection string"
az webapp config connection-string set -g ${resourceGroupName} -n ${apiAppserviceName} -t DocDb --settings DocDb=${connectionString}


