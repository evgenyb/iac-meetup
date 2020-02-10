#!/usr/bin/env bash

environment=dev
tfmResourceGroupName="iac-$environment-rg"
tfmProfileName="iac-$environment-tfm"

echo -e "Set iac-dev-blue-api to 50%"
az network traffic-manager endpoint update -g ${tfmResourceGroupName} --profile-name ${tfmProfileName} -n iac-dev-blue-api --type azureEndpoints --endpoint-status enabled --weight 50

echo -e "Set iac-dev-green-api to 50%"
az network traffic-manager endpoint update -g ${tfmResourceGroupName} --profile-name ${tfmProfileName} -n iac-dev-green-api --type externalEndpoints --endpoint-status enabled --weight 50

