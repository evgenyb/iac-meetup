# lab-08 - refactoring: introduce parameters

Parameters are the powerful way to make your ARM templates re-usable. If your infrastructure looks the same between several environments, then you can implement one template, identify the differences between environments, implement them as parameters and specify them at the deployment time.

If we look at our example, the following items are candidates to be defined as parameters:

* environment
* location
* aks subnet address prefix
* agw subnet address prefix
* vnet address prefix

## Task #1 - create `location` parameter at nsg ARM template

Create new parameter called `location` with default value `westeurope`. Use `[parameters('location')]` for location everywhere in the template.

### Validate template

```bash
az group deployment validate -g iac-dev-rg --template-file template.json --parameters location=westeurope
```

Note, that we need to specify value for parameter `location` as part of the script

### Deploy template

```bash
az group deployment create -g iac-dev-rg --template-file template.json --parameters location=westeurope
```

## Task #2 - create `environment` parameter at nsg ARM template

Create new parameter called `environment` with no default value. Use `[parameters('environment')]` for environment everywhere in the template.

### Validate templates

```bash
az group deployment validate -g iac-dev-rg --template-file template.json --parameters location=westeurope --parameters environment=dev
```

Note, that we now need to specify both `location` and `environment` as parameters

### Deploy templates

```bash
az group deployment create -g iac-dev-rg --template-file template.json --parameters location=westeurope --parameters environment=dev
```

## Task #3 - create `agwSubnetAddressPrefix` parameter at nsg and vnet ARM templates

Create new parameter called `agwSubnetAddressPrefix` with no default value. Use `[parameters('agwSubnetAddressPrefix')]` everywhere in the template where agw subnet prefix is used.

Validate and deploy templates

## Task #4 - create `aksSubnetAddressPrefix` parameter at nsg and vnet ARM templates

Create new parameter called `aksSubnetAddressPrefix` with no default value. Use `[parameters('aksSubnetAddressPrefix')]` everywhere in the template where aks subnet prefix is used.

Validate and deploy templates

## Task #5 - create `vnetAddressPrefix` parameter at vnet ARM template

Create new parameter called `vnetAddressPrefix` with no default value. Use `[parameters('vnetAddressPrefix')]` everywhere in the template where vnet address prefix is used.

Validate and deploy template
