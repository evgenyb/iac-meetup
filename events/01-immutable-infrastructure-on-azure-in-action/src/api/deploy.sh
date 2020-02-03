#!/usr/bin/env bash

environment=$1
resourceGroupName="iac-$environment-rg"
apiWebAppName="iac-$environment-api-appservice"

publish.sh
az webapp deployment source config-zip -g ${resourceGroupName} -n ${apiWebAppName} --src "./api.zip"