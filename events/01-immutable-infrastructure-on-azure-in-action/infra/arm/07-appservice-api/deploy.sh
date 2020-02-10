#!/usr/bin/env bash
#
# Usage:
# ./deploy.sh dev blue

environment=$1
slot=$2
timestamp=`date "+%Y%m%d-%H%M%S"`
deploymentName="appservice-api-$environment-${timestamp}"

baseResourceGroupName="iac-$environment-rg"
resourceGroupName="iac-$environment-$slot-rg"
apiAppserviceName="iac-$environment-$slot-api-appservice"
vnetName="iac-${environment}-$slot-vnet"
cosmosDbName="iac-$environment-cosmosdb"

az group deployment create -g ${resourceGroupName} --template-file template.json --parameters parameters-${environment}-${slot}.json -n ${deploymentName}

echo -e "Setting up vnet integration with ${vnetName}"
az webapp vnet-integration add -g ${resourceGroupName} -n ${apiAppserviceName} --vnet ${vnetName} --subnet integration-net

echo -e "Get connection string for cosmosdb ${cosmosDbName}"
connectionString=$(az cosmosdb keys list --name ${cosmosDbName} --resource-group ${baseResourceGroupName} --type connection-strings --query "connectionStrings[0].connectionString" | jq . -r)

echo -e "Add  cosmosdb connection string to ${apiAppserviceName}"
az webapp config connection-string set -g ${resourceGroupName} -n ${apiAppserviceName} -t DocDb --settings DocDb=${connectionString} 1> /dev/null