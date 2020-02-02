#!/usr/bin/env bash
#
# Usage:
# ./deploy.sh initial

environment=$1
timestamp=`date "+%Y%m%d-%H%M%S"`
deploymentName="agw-$environment-${timestamp}"
resourceGroupName="iac-$environment-rg"

az group deployment create -g ${resourceGroupName} --template-file template.json --parameters parameters-${environment}.json -n ${deploymentName}
