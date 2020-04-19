# lab-07 - refactoring: introduce variables and implement naming convention with variables

## Task #1 - use variables for subnet IP prefix (both in nsg and vnet templates)

Add new variable called `agwSubnetAddressPrefix` with value `10.112.16.128/25`. Replace all hard-coded values with new variable.
Add new variable called `aksSubnetAddressPrefix` with value `10.112.0.0/20`. Replace all hard-coded values with new variable.

## Task 2 - andd new `environment` variable (both in nsg and vnet templates)

Add new variable called `environment` with value `dev`.

## Task 3 - use variable to define resource name

Introduce new variables called `agwNsgName`, `agwNsgName` and `vnetName`. Use `concat` function to compose resource names by followed our naming convention (`iac-<environment>-agw-nsg`, `iac-<environment>-aks-nsg` and `iac-<environment>-vnet`).
Use `agwNsgName`, `aksNsgName` and `vnetName` variables in resource definition instead of hard-coded values in both nsg and vnet template files.

## Task 4 - add new `location` variable (both in nsg and vnet templates)

Introduce new variable `location` with value `westeurope`. Use `location` variable instead of hard-coded values in both nsg and vnet template files.

## Next

[Go to lab-08](../lab-08/readme.md)
