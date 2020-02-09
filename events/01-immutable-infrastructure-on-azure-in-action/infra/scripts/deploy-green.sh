#!/usr/bin/env bash
#
# Usage
# ./deploy-green.sh dev
#

environment=$1
slot=green

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

