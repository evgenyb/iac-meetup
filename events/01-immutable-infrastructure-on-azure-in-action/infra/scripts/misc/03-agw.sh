#!/usr/bin/env bash

resourceGroupName="iac-initial-rg"
vnetName="iac-initial-vnet"

az network application-gateway create -g ${resourceGroupName} -n iac-initial-agw --capacity 1 --sku Standard_Small \
    --vnet-name ${vnetName} --subnet agw-net --public-ip-address MyAppGatewayPublicIp