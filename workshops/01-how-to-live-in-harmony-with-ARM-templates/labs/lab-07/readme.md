# lab-07 - refactoring: introduce variables and implement naming convention with variables

Variables are very powerful concept in ARM templates. You use variables to simplify your templates. Rather than repeating complicated expressions throughout your template, you define a variable that contains the complicated expression. Then, you reference that variable as needed throughout your template.

## Estimated completion time - 15 min

## Useful links

* [Variables in Azure Resource Manager template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-variables)
* [concat() function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-array#concat)
* [Tutorial: Add variables to your ARM template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-add-variables?tabs=azure-powershell)

## Task #1 (optional) - copy `lab-05` folder to `lab-07` folder

## Task #2 - introduce variables in bsg ARM template

Add the following variables to the nsg ARM template
| Variable |Value |
|---|---|
| environment | dev|
| location | westeurope|
| agwSubnetAddressPrefix | 10.112.16.128/25 |
| aksSubnetAddressPrefix | 10.112.0.0/20 |
| agwNsgName | iac-{environment}-agw-nsg |
| aksNsgName | iac-{environment}-aks-nsg|

Use `concat` function to compose resource names by followed our naming convention (`iac-<environment>-agw-nsg`, `iac-<environment>-aks-nsg`) and use earlier defined variable `environment` as a parameter for `concat` function.

Reference variables wherever needed throughout your template.

Validate and deploy

## Task #3 - introduce variables in vnet ARM template

Add the following variables to the nsg ARM template
| Variable |Value |
|---|---|
| environment | dev|
| location | westeurope|
| vnetAddressPrefix | 10.112.0.0/16 |
| agwSubnetAddressPrefix | 10.112.16.128/25 |
| aksSubnetAddressPrefix | 10.112.0.0/20 |
| vnetName | iac-{environment}-vnet |
| agwNsgName | iac-{environment}-agw-nsg |
| aksNsgName | iac-{environment}-aks-nsg|

Use `concat` function to compose resource names by followed our naming convention (`iac-<environment>-vnet`, `iac-<environment>-agw-nsg`, `iac-<environment>-aks-nsg`) and use variable `environment` as a parameter for `concat` function.

Reference variables wherever needed throughout your template.

Validate and deploy

## Next

[Go to lab-08](../lab-08/readme.md)
