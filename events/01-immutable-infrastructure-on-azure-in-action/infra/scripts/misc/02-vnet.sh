#!/usr/bin/env bash

resourceGroupName="iac-initial-rg"
vnetName="iac-initial-vnet"
az network vnet create -g ${resourceGroupName} -n ${vnetName} --address-prefixes 10.200.0.0/26
az network vnet subnet create -n agw-net --address-prefixes 10.200.0.0/27 --vnet-name ${vnetName} -g ${resourceGroupName}
az network vnet subnet create -n integration-net --address-prefixes 10.200.0.32/27 --vnet-name ${vnetName} -g ${resourceGroupName}
