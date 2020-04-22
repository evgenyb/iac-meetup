#!/usr/bin/env bash

az group deployment validate --template-file template.json -g iac-dev-rg \
    --parameters location=westeurope \
    --parameters environment=dev \
    --parameters agwSubnetAddressPrefix='10.112.16.128/25' \
    --parameters aksSubnetAddressPrefix='10.112.0.0/20' \
    -o table