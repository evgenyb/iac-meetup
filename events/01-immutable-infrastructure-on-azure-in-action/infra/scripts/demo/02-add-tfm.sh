#!/usr/bin/env bash

environment=dev
resourceGroupName="iac-$environment-rg"
tfmProfileName="iac-$environment-tfm"
pipName="iac-$environment-agw-pip"

echo -e "Create Traffic Manage profile"
az network traffic-manager profile create -g ${resourceGroupName} -n ${tfmProfileName} --routing-method Weighted --unique-dns-name ${tfmProfileName} --ttl 0 --protocol HTTP --port 80 --path "/api/health/ready"

echo -e "Get AGW PIP id"
pipid=$(az network public-ip show -g ${resourceGroupName} -n ${pipName} --query id | jq . -r)

echo -e "Create Traffic Manage endpoint"
az network traffic-manager endpoint create -g ${resourceGroupName} --profile-name ${tfmProfileName} -n iac-dev-api --type azureEndpoints --target-resource-id ${pipid} --endpoint-status enabled --weight 100
