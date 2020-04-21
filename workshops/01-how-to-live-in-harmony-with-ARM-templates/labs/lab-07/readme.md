# lab-07 - refactoring: introduce variables and implement naming convention with variables

Variables are very powerful concept in ARM templates. You use variables to simplify your templates. Rather than repeating complicated expressions throughout your template, you define a variable that contains the complicated expression. Then, you reference that variable as needed throughout your template.

## Task #1 - introduce variables in bsg ARM template

Add the following variables to the nsg ARM template
| Variable |Value |
|---|---|
| environment | dev|
| location | westeurope|
| agwSubnetAddressPrefix | 10.112.16.128/25 |
| aksSubnetAddressPrefix | 10.112.0.0/20 |

Reference variables wherever needed throughout your template.

## Task #2 - use variable to build nsg resource name

Add 2 new variables

| Variable | Value |
|---|---|
| agwNsgName | iac-{environment}-agw-nsg |
| aksNsgName | iac-{environment}-aks-nsg|

Use `concat` function to compose resource names by followed our naming convention (`iac-<environment>-agw-nsg`, `iac-<environment>-aks-nsg`) and use earlier defined variable `environment` as a parameter for `concat` function.
Reference `agwNsgName` and `aksNsgName` variables wherever needed throughout your template.

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

Reference variables wherever needed throughout your template.

## Task #4 - use variable to build nsg resource name

Add 2 new variables

| Variable | Value |
|---|---|
| vnetName | iac-{environment}-vnet |

Use `concat` function to compose resource names by followed our naming convention (`iac-<environment>-vnet`) and use earlier defined variable `environment` as a parameter for `concat` function.
Reference `vnetName` variable wherever needed throughout your template.

Validate and deploy

## Next

[Go to lab-08](../lab-08/readme.md)
