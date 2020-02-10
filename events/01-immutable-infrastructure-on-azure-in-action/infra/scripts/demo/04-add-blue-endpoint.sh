#!/usr/bin/env bash

environment=dev
slot=blue
tfmResourceGroupName="iac-$environment-rg"
tfmProfileName="iac-$environment-tfm"
resourceGroupName="iac-$environment-$slot-rg"
pipName="iac-$environment-$slot-agw-pip"

echo -e "Get AGW PIP id"
pipid=$(az network public-ip show -g ${resourceGroupName} -n ${pipName} --query id | jq . -r)

echo -e "Add Traffic Manage endpoint"
az network traffic-manager endpoint create -g ${tfmResourceGroupName} --profile-name ${tfmProfileName} -n iac-dev-blue-api --type azureEndpoints --target-resource-id ${pipid} --endpoint-status disabled --weight 10
