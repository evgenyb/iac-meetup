# lab-04 - refactoring: splitting one ARM template to ARM template per resource type and move them into it's own folder

The gaol for this lab is to refactor one big ARM template with 3 resources into 2 ARM templates: one for network security groups and one for private vnet. Splitting one big ARM template will reduce the size of the ARM template and will improve our structure. Later, if you want to implement CI/CD pipeline, it will be easier to setup commit triggers and only deploy resources that were changed. For example, if I added new security rule, I don't need to deploy vnet, etc...

## Task #1 - copy `template.json` from `lab-03` into `lab-04` folder

## Task #2 - create new `template.json` file inside `01-nsg` folder and move nsg ARM resources section from `template.json` into this file

Validate NSG template

```bash
az group deployment validate --template-file template.json -g iac-dev-rg
```

Deploy NSG template

```bash
az group deployment create --template-file template.json -g iac-dev-rg
```

## Task #3 - cerate `validate.sh` and `deploy.sh` files (if you prefer PowerShell, feel free to create 2 PowerShell files `validate.ps1` and `deploy.ps1`) to validate and deploy vnet

As you probably already noticed, it's time consuming to type validate and deploy commands every time we apply changes. Therefore I recommend to create 2 files called `validate.sh` and `deploy.sh` at the template file level and implement validation and deployment commands.  

Use validate command for `validate.[sh|ps1]` file

```bash
az group deployment validate --template-file template.json -g iac-dev-rg
```

Use deploy command for `deploy.[sh|ps1]` file.

Note that for deployment command we use `-n` flag and building unique and self-explained name of the deployment.

### For bash

```bash
timestamp=`date "+%Y%m%d-%H%M%S"`

az group deployment create --template-file template.json -g iac-dev-rg -n "nsg-dev-${timestamp}"
```

### For powershell

```powershell
$timestamp=$(Get-Date -Format "yyyyMMdd-HHmmss")

az group deployment create --template-file template.json -g iac-dev-rg -n "nsg-dev-$timestamp"
```

## Task #4 - create new `template.json` file inside `02-vnet` folder and move vnet ARM resources section from `template.json` into this file

Validate VNet template

```bash
az group deployment validate --template-file template.json -g iac-dev-rg
```

Deploy VNet template

```bash
az group deployment create --template-file template.json -g iac-dev-rg
```

## Task #6 - cerate `validate.sh` and `deploy.sh` files (if you prefer PowerShell, feel free to create 2 PowerShell files `validate.ps1` and `deploy.ps1`) to validate and deploy vnet

The motivation is the same as for Task #3. Create 2 files called `validate.sh` and `deploy.sh` at the template file level and implement validation and deployment commands.  

Use validate command for `validate.[sh|ps1]` file

```bash
az group deployment validate --template-file template.json -g iac-dev-rg
```

Use deploy command for `deploy.[sh|ps1]` file.

Note that for deployment command we use `-n` flag and building unique and self-explained name of the deployment.

### For bash

```bash
timestamp=`date "+%Y%m%d-%H%M%S"`

az group deployment create --template-file template.json -g iac-dev-rg -n "vnet-dev-${timestamp}"
```

### For powershell

```powershell
$timestamp=$(Get-Date -Format "yyyyMMdd-HHmmss")

az group deployment create --template-file template.json -g iac-dev-rg -n "vnet-dev-$timestamp"
```

## Checkpoint

At this point your folders structure should look something like this

```txt
    lab-04
        01-nsg
            deploy.sh
            template.json
            validate.sh
        02-vnet
            deploy.sh
            template.json
            validate.sh
```


## Task #7 (optional) - if you want to go even far in splitting resources, you can implement one ARM template per nsg

In this case, you can either implement them as sub-folders under `01-nsg`, so you folder structure will look like this:

```txt
    01-nsg
        01-agw
            template.json
        02-aks
            template.json
    02-vnet
        template.json
```

or you can keep a "flat" structure and change each of the nsg folders with `-nsg` suffix.

```txt
    01-nsg-agw
        template.json
    02-aks-nsg
        template.json
    03-vnet
        template.json
```

## Next

[Go to lab-05](../lab-05/readme.md)
