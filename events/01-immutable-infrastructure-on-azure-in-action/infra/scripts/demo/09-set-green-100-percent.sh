#!/usr/bin/env bash

environment=dev
tfmResourceGroupName="iac-$environment-rg"
tfmProfileName="iac-$environment-tfm"

echo -e "Set iac-dev-green-api to 100%"
az network traffic-manager endpoint update -g ${tfmResourceGroupName} --profile-name ${tfmProfileName} -n iac-dev-green-api --type externalEndpoints --endpoint-status enabled --weight 100

echo -e "Disable iac-dev-blue-api"
az network traffic-manager endpoint update -g ${tfmResourceGroupName} --profile-name ${tfmProfileName} -n iac-dev-blue-api --type azureEndpoints --endpoint-status disabled --weight 1


