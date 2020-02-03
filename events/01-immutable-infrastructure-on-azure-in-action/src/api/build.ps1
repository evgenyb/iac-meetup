Param(
    [string] [Parameter(Mandatory = $true)] $environment
)

#Remove-Item api.zip -Force
$solutionFile = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "..\api.sln"))


& "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\amd64\msbuild.exe" $solutionFile /nologo /nr:false /m /p:DeployOnBuild=true /p:PublishProfile=publish-local
$publishFolder = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "publish"))
$publishFolder = $publishFolder + "\*"
Write-Output $publishFolder

Compress-Archive -Path $publishFolder -DestinationPath api.zip -Force
