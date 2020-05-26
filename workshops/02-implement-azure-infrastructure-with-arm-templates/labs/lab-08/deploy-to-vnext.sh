#!/usr/bin/env bash
# Usage:
#   ./deploy-to-vnext.sh webapp
# 
webappFolder=$1

echo -e "Install front-door extension"
az extension add -n front-door

frontDoorName="<Use your FD name>"
frontDoorResourceGroupName="iac-ws2-rg"

echo -e "Get vnext slot name from Front Dore instance"
activeSlot=$(az network front-door backend-pool list -f ${frontDoorName} -g ${frontDoorResourceGroupName} --query [0].name -o tsv)

vnextSlot=""
if [[ ${activeSlot} == "blue" ]]; then
    vnextSlot="green"
fi
if [[ ${activeSlot} == "green" ]]; then
    vnextSlot="blue"
fi

storageAccountName="iacws2evg${vnextSlot}as"

echo -e "Deploying webapp to ${storageAccountName}"
az storage blob upload-batch \
    -s ${webappFolder} \
    -d \$web \
    --account-name ${storageAccountName}