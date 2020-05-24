#!/usr/bin/env bash
# Usage:
#   ./deploy-active.sh ../../../src/web
# 
webappFolder=$1

echo -e "Install front-door extension"
az extension add -n front-door

frontDoorName="iac-ws2-evg-fd"
frontDoorResourceGroupName="iac-ws2-rg"

echo -e "Get active slot name from Front Dore instance"
activeSlot=$(az network front-door backend-pool list -f ${frontDoorName} -g ${frontDoorResourceGroupName} --query [0].name -o tsv)
storageAccountName="iacws2evg${activeSlot}as"

echo -e "Deploying webapp to ${storageAccountName}"
az storage blob upload-batch \
    -s ${webappFolder} \
    -d \$web \
    --account-name ${storageAccountName}