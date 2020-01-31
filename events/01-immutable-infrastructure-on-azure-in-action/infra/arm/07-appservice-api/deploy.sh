#!/usr/bin/env bash
#
# Usage:
# ./deploy.sh initial

environment=$1
timestamp=`date "+%Y%m%d-%H%M%S"`
deploymentName="appservice-api-$environment-${timestamp}"

resourceGroupName="iac-$environment-rg"
apiAppserviceName="iac-$environment-api-appservice"

az group deployment create -g ${resourceGroupName} --template-file template.json --parameters parameters-${environment}.json -n ${deploymentName}

echo -e "Setting up vnet integration"
az webapp vnet-integration add -g ${resourceGroupName} -n ${apiAppserviceName} --vnet iac-initial-vnet --subnet integration-net

echo -e "Get connection string for cosmosdb"
connectionString=$(az cosmosdb keys list --name iac-initial-cosmosdb --resource-group ${resourceGroupName} --type connection-strings --query "connectionStrings[0].connectionString" | jq . -r)

echo -e "Set connection string"
az webapp config connection-string set -g ${resourceGroupName} -n ${apiAppserviceName} -t DocDb --settings DocDb=${connectionString}