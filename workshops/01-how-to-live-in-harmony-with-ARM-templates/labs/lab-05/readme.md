# lab-05 - introducing master script

During lab-04 we split one monolithic ARM template into set of small ARM templates located each in its own folder. We also implemented deployment and validation scripts than make our deployment and validation tasks easier. What we are missing now is possibility to deploy all our resources. The only way one can deploy both network security group resources and vnet is to manually go to each folder and execute `deploy.sh` script in correct order (remember, the monolithic template uses `dependson` concept to orchestrate in which order resources should be deployed).
To solve this issue in our new structure, we need to implement "master" deployment script. The simplest version (which we will use) will look something like this:

```bash
#!/usr/bin/env bash

cd ./01-nsg
./deploy.sh 
cd ../02-vnet
./deploy.sh 
cd ..
```

## Task #1 (optional) - copy `lab-04` folder to `lab-05` folder

## Task #2 - implement master `validate.sh` bash (or powershell) script

Implement `validate.sh` script that will execute `validate.sh` scripts from both `01-nsg` and `02-vnet` folders.
Validate all resources with new master validation script.

## Task #3 - implement master `deploy.sh` bash (or powershell) script

Implement `deploy.sh` script that will execute `deploy.sh` scripts from both `01-nsg` and `02-vnet` folders.
Validate all resources with new master validation script.

## Checkpoints

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
    deploy.sh
    validate.sh
```

## Next

[Go to lab-06](../lab-06/readme.md)
