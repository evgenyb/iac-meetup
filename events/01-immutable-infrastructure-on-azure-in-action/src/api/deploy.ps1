Param(
    [string] [Parameter(Mandatory = $true)] $environment
)

.\build.ps1 dev

Write-Output 'Deploy api to $resourceGroupName'
az webapp deployment source config-zip -g $resourceGroupName -n $apiWebAppName --src "./api.zip"

