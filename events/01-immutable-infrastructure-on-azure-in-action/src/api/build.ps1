Param(
    [string] [Parameter(Mandatory = $true)] $environment
)

Remove-Item api.zip -Force
& "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\amd64\msbuild.exe" "..\api.sln" /nologo /nr:false /m /p:DeployOnBuild=true /p:PublishProfile=publish-local
Compress-Archive -Path ".\publish\*" -DestinationPath api.zip -Force
$resourceGroupName = 'iac-' + $environment + '-rg'
$apiWebAppName = 'iac-' + $environment + '-api-appservice'
