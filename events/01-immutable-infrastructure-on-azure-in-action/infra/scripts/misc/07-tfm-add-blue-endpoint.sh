#!/usr/bin/env bash

#
# Usage:
# ./07-tfm-add-blue-endpoint.sh dev 50

environment=$1
weight=$2

resourceGroupName="iac-$environment-rg"
tfmProfileName="iac-$environment-tfm"
pipName="iac-$environment-agw-pip"

pipid=$(az network public-ip show -g ${resourceGroupName} -n ${pipName} --query id | jq . -r)
echo -e "Create Traffic Manage endpoint"
az network traffic-manager endpoint create -g ${resourceGroupName} --profile-name ${tfmProfileName} -n iac-app --type azureEndpoints --target-resource-id ${pipid} --endpoint-status enabled --weight ${weight}
