#!/usr/bin/env bash

environment=dev
slot=blue
tfmResourceGroupName="iac-$environment-rg"
tfmProfileName="iac-$environment-tfm"

echo -e "Add green endpoint"
az network traffic-manager endpoint create -g ${tfmResourceGroupName} --profile-name ${tfmProfileName} -n iac-dev-green-api --type externalEndpoints --target iac-dev-green-apim.azure-api.net --endpoint-status disabled --weight 10
