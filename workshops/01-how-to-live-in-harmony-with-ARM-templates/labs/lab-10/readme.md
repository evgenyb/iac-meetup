# lab-10 - refactoring: move environment specific configuration to environment parameters file

All parameters we worked until now belongs to the `dev` environment. If we have several environments, we can introduce parameter file with the following convention `parameters-{environment}.json`. This way, we will have one ARM template at `template.json` and several parameters files, one per environment. During the deployment, we need to specify what environment we want to deploy to and use correct parameters file for deployment script and this is easily done with simple string function in the script.

## Estimated completion time - 10 min

## Task #1 (optional) - copy `lab-09` folder to `lab-10` folder

## Task #2 - introduce environment specific parameters file for nsg ARM template

In `01-nsg` folder rename `parameters.json` file  to `parameters-dev.json` file.

Make necessary changes at `validate.sh` and `deploy.sh` files.

Validate and deploy

## Task #3 - send environment as an input parameter to the script

Based on the input parameter we need to compose name of resource group, name of the parameters file and deployment name. Here is my implementation

```bash
#!/usr/bin/env bash
#
# usage: ./validate.sh dev
# 
environment=$1

resourceGroupName='iac-${environment}-rg'

az group deployment validate -g ${resourceGroupName} --template-file template.json --parameters @parameters-${environment}.json -o table
```

```bash
#!/usr/bin/env bash
#
# usage: ./deploy.sh dev
# 
environment=$1

resourceGroupName='iac-${environment}-rg'
timestamp=`date "+%Y%m%d-%H%M%S"`
deploymentName='nsg-${environment}-${timestamp}'

az group deployment validate -g ${resourceGroupName} --template-file template.json --parameters @parameters-${environment}.json -n ${deploymentName} -o table --verbose
```

Validate

```bash
./validate.sh dev
```

Deploy

```bash
./deploy.sh dev
```

## Task #4 - introduce environment specific parameters file for vnet ARM template

In `02-vnet` folder rename `parameters.json` file  to `parameters-dev.json` file.

Make necessary changes at `validate.sh` and `deploy.sh` files.

Validate and deploy

## Task #5 - send environment as an input parameter to the script

Based on the input parameter we need to compose name of resource group, name of the parameters file and deployment name. Here is my implementation

```bash
#!/usr/bin/env bash
#
# usage: ./validate.sh dev
# 
environment=$1
resourceGroupName='iac-${environment}-rg'

az group deployment validate -g ${resourceGroupName} --template-file template.json --parameters @parameters-${environment}.json -o table
```

```bash
#!/usr/bin/env bash
#
# usage: ./deploy.sh dev
# 
environment=$1

resourceGroupName='iac-${environment}-rg'
timestamp=`date "+%Y%m%d-%H%M%S"`
deploymentName='vnet-${environment}-${timestamp}'

az group deployment validate -g ${resourceGroupName} --template-file template.json --parameters @parameters-${environment}.json -n ${deploymentName} -o table --verbose
```

Validate

```bash
./validate.sh dev
```

Deploy

```bash
./deploy.sh dev
```

## Task #6 - send environment as an input parameter to the master validate and deployment scripts

Use the same technique as at tasks #3 and #5 and introduce input parameter to validate and deploy scripts.

## Checkpoints

Make sure that you still can validate and deploy by using master validate and deploy scripts.

## Next

[Go to lab-11](../lab-11/readme.md)
