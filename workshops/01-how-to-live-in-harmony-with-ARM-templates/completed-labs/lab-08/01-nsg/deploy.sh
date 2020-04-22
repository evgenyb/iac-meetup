#!/usr/bin/env bash

timestamp=`date "+%Y%m%d-%H%M%S"`

az group deployment create --template-file template.json -g iac-dev-rg \
    --parameters location=westeurope \
    --parameters environment=dev \
    --parameters agwSubnetAddressPrefix='10.112.16.128/25' \
    --parameters aksSubnetAddressPrefix='10.112.0.0/20' \
    -n "nsg-dev-${timestamp}" -o table