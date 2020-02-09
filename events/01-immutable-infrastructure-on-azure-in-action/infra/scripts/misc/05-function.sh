#!/usr/bin/env bash
envr=$1	# dev-green
resourceGroupName=iac-$envr-rg

az functionapp create -g iac-$envr-rg --consumption-plan-location westeurope -n ias-$envr-fapp-1 -s iacdevgreensa --runtime dotnet --os-type Windows --disable-app-insights



