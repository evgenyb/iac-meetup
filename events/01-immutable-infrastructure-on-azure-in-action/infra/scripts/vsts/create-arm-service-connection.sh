#!/usr/bin/env bash
# Creates new VSTS azurerm Service Connection.
# SPN details (clientid, secret, etc...) are retrieved from the metadata keyvault.
#
# usage:
#  ./create-arm-service-connection.sh evgeny.borzenin@gmail.com <vsts_token> dev blue
#

username=$1                     # user@email
vstsPersonalAccessToken=$2      # Generate it at vsts profile page https://dev.azure.com/ifoobar/_usersSettings/tokens
environment=$3
slot=$4

keyVaultName="iac-$environment-infra-kv"
vstsApiUrl="https://dev.azure.com/ifoobar/iac"

echo -e "Reading spn metadata from $keyVaultName keyvault..."
vsts_spn_appid=$(az keyvault secret show --name vsts-spn-appid --vault-name ${keyVaultName} --query value | jq . -r)
vsts_spn_objectid=$(az keyvault secret show --name vsts-spn-objectid --vault-name ${keyVaultName} --query value | jq . -r)
vsts_spn_secret=$(az keyvault secret show --name vsts-spn-secret --vault-name ${keyVaultName} --query value | jq . -r)
vsts_spn_subscriptionid=$(az keyvault secret show --name vsts-spn-subscriptionid --vault-name ${keyVaultName} --query value | jq . -r)
vsts_spn_subscription_name=$(az keyvault secret show --name vsts-spn-subscription-name --vault-name ${keyVaultName} --query value | jq . -r)
vsts_spn_tenantid=$(az keyvault secret show --name vsts-spn-tenantid --vault-name ${keyVaultName} --query value | jq . -r)

serviceConnectionName="iac-$environment-$slot-arm"

echo -e "Transforming template templates/arm-service-connection-template.json -> arm-service-connection.json"
cp ./templates/arm-service-connection-template.json arm-service-connection.json
sed -i -e 's/{service-connection-name}/'${serviceConnectionName}'/g' arm-service-connection.json
sed -i -e 's/{subscription-id}/'${vsts_spn_subscriptionid}'/g' arm-service-connection.json
sed -i -e 's/{subscription-name}/'"${vsts_spn_subscription_name}"'/g' arm-service-connection.json
sed -i -e 's/{spn-id}/'${vsts_spn_appid}'/g' arm-service-connection.json
sed -i -e 's/{spn-secret}/'${vsts_spn_secret}'/g' arm-service-connection.json
sed -i -e 's/{tenant-id}/'${vsts_spn_tenantid}'/g' arm-service-connection.json

echo -e "Check if Service Connection $serviceConnectionName already exists..."
serviceConnectionId=$(curl -s -u ${username}:${vstsPersonalAccessToken} \
    -X GET "$vstsApiUrl/_apis/serviceendpoint/endpoints?endpointNames=$serviceConnectionName&type=azurerm" \
    -H 'content-type: application/json' \
    -H 'accept: application/json;api-version=5.0-preview.2;excludeUrls=true' | jq .value[0].id -r)

if [[ "$serviceConnectionId" != "null" ]]; then
    sed -i -e 's/{id}/'${serviceConnectionId}'/g' arm-service-connection.json

    echo -e "Updating VSTS service connection $serviceConnectionName ($serviceConnectionId)."
    curl -s -u ${username}:${vstsPersonalAccessToken}  \
        -X PUT  "$vstsApiUrl/_apis/serviceendpoint/endpoints/$serviceConnectionId" \
        -H 'content-type: application/json' \
        -H 'accept: application/json;api-version=5.0-preview.2;excludeUrls=true' \
        --data-binary "@arm-service-connection.json" 1> /dev/null
else
    sed -i -e 's/{id}/'-1'/g' arm-service-connection.json
    resultJson=$(curl -s -u ${username}:${vstsPersonalAccessToken} \
        -X POST  "$vstsApiUrl/_apis/serviceendpoint/endpoints" \
        -H 'content-type: application/json' \
        -H 'accept: application/json;api-version=5.0-preview.2;excludeUrls=true' \
        --data-binary "@arm-service-connection.json")

    serviceConnectionId=$(echo ${resultJson} | jq .id -r)
    echo -e  "New arm Service Connection $serviceConnectionName was successfully created with id# $serviceConnectionId"
fi

echo -e "Go to Service Connection definition $vstsApiUrl/_settings/adminservices?_a=resources&resourceId=$serviceConnectionId"
rm -f arm-service-connection.json