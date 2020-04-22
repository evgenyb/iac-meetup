#!/usr/bin/env bash
environment=$1
resourceGroupName="iac-${environment}-rg"

timestamp=`date "+%Y%m%d-%H%M%S"`

az group deployment create --template-file template.json -g ${resourceGroupName} \
    --parameters @parameters-${environment}.json \
    -n "nsg-${environment}-${timestamp}" -o table