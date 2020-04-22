#!/usr/bin/env bash
environment=$1
resourceGroupName="iac-${environment}-rg"

echo -e "Validating vnet deployment to rg $resourceGroupName"
az group deployment validate --template-file template.json -g ${resourceGroupName} \
    --parameters @parameters-${environment}.json \
    -o table