#!/usr/bin/env bash
environment=$1

resourceGroupName="iac-$environment-rg"
keyVaultName="iac-$environment-infra-kv"
vstsSpnName="iac-$environment-spn"

echo -e "Create keyvault ${keyVaultName} in resource group ${resourceGroupName}"
az keyvault create --name ${keyVaultName} --resource-group ${resourceGroupName} --location westeurope

echo -e "Check if spn ${vstsSpnName} already exists..."
jsonResult=$(az ad sp list --display-name ${vstsSpnName} --query "[0].{appId:appId, objectId:objectId}")
if [[ -z "$jsonResult" ]]; then
    rgid=$(az group show -n ${resourceGroupName} --query id | jq . -r)
    echo -e "Creating spn $vstsSpnName with contributor access scoped to $rgid"
    createdSpn=$(az ad sp create-for-rbac --name ${vstsSpnName} --role contributor --scopes ${rgid} --years 99 --query "{appId:appId, password:password}")
    vstsSpnAppId=$(echo ${createdSpn} | jq '.appId' -r)
    spnSecret=$(echo ${createdSpn} | jq '.password' -r)

    jsonResult=$(az ad sp list --display-name ${vstsSpnName} --query "[0].{objectId:objectId, tenantId:appOwnerTenantId }")
    vstsSpnObjectId=$(echo ${jsonResult} | jq '.objectId' -r)
    tenantId=$(echo ${jsonResult} | jq '.tenantId' -r)

    echo "Set _get, list, set_ access policy for spn $vstsSpnObjectId at keyvault $keyVaultName"
    az keyvault set-policy --name ${keyVaultName} --object-id ${vstsSpnObjectId} --secret-permissions get list set 1> /dev/null

    accountInfo=$(az account show --query "{subscriptionId:id, subscriptionName:name}")
    subscriptionId=$(echo ${accountInfo} | jq '.subscriptionId' -r)
    subscriptionName=$(echo ${accountInfo} | jq '.subscriptionName' -r)

    echo "Storing SPN $vstsSpnName connection details to key-vault $keyVaultName"
    az keyvault secret set -n "vsts-spn-objectid" --vault-name ${keyVaultName} --value ${vstsSpnObjectId} 1> /dev/null
    az keyvault secret set -n "vsts-spn-appid" --vault-name ${keyVaultName} --value ${vstsSpnAppId} 1> /dev/null
    az keyvault secret set -n "vsts-spn-secret" --vault-name ${keyVaultName} --value ${spnSecret} 1> /dev/null
    az keyvault secret set -n "vsts-spn-tenantid" --vault-name ${keyVaultName} --value ${tenantId} 1> /dev/null
    az keyvault secret set -n "vsts-spn-subscriptionid" --vault-name ${keyVaultName} --value ${subscriptionId} 1> /dev/null
    az keyvault secret set -n "vsts-spn-subscription-name" --vault-name ${keyVaultName} --value "$subscriptionName" 1> /dev/null
else
    echo "Spn already exists. Do nothing..."
fi
