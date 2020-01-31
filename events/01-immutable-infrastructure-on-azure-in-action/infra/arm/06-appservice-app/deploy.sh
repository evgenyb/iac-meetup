#!/usr/bin/env bash
#
# Usage:
# ./deploy.sh initial

environment=$1
timestamp=`date "+%Y%m%d-%H%M%S"`
deploymentName="appservice-app-$environment-${timestamp}"

az group deployment create -g iac-${environment}-rg --template-file template.json --parameters parameters-${environment}.json -n ${deploymentName}