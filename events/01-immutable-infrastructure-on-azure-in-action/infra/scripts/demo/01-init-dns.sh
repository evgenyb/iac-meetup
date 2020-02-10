#!/usr/bin/env bash

environment=dev
resourceGroupName="iac-$environment-rg"

echo -e "Set CNAME for iac-dev.ifoobar.no towards iac-dev-agw-pip.westeurope.cloudapp.azure.com"
az network dns record-set cname set-record -g domains-and-certificates -z ifoobar.no  -n iac-dev -c iac-dev-agw-pip.westeurope.cloudapp.azure.com --ttl 0
