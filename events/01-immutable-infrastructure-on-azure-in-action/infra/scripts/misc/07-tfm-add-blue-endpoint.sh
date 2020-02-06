#!/usr/bin/env bash

environment=$1
slot=$2
baseResourceGroupName="iac-$environment-rg"
resourceGroupName="iac-$environment-$slot-rg"
tfmProfileName="iac-$environment-tfm"
pipName="iac-$environment-$slot-agw-pip"

pipid=$(az network public-ip show -g ${resourceGroupName} -n ${pipName} --query id | jq . -r)
echo -e "Create Traffic Manage endpoint"
az network traffic-manager endpoint create -g ${baseResourceGroupName} --profile-name ${tfmProfileName} -n iac-app-blue --type azureEndpoints --target-resource-id ${pipid} --endpoint-status enabled --weight 5
