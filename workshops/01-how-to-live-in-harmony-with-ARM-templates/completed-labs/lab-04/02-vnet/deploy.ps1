$timestamp=$(Get-Date -Format "yyyyMMdd-HHmmss")

az group deployment create --template-file template.json -g iac-dev-rg -n "vnet-dev-$timestamp"