# Lab-07 - create YAML based Front Door CI/CD pipeline

Storage account CI/CD pipelines were implemented as classic Azure DevOps pipelines. To give you hands-on feeling what it takes to work with YAML based pipelines, let's implement Front Door pipeline using YAML syntax.

![pipelines-image-yaml](https://docs.microsoft.com/en-us/azure/devops/pipelines/media/pipelines-image-yaml.png?view=azure-devops)

## Estimated completion time - x min

## Useful links

* [YAML schema reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema)
* [Use Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops)
* [What is Azure Pipelines?](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)
* [Key concepts for new Azure Pipelines users](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops)
* [Multi-stage pipelines user experience](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/multi-stage-pipelines-experience?view=azure-devops)

## Task #1 - create empty YAML based pipeline

### Create new pipeline

![task-1-1](images/task-1-1.png)

### Select where is your source code located

![task-1-2](images/task-1-2.png)

### Select your repository

![task-1-3](images/task-1-3.png)

### Select `Starter pipeline`

![task-1-4](images/task-1-4.png)

### Configure your pipeline

![task-1-5](images/task-1-5.png)

* Set the name of the pipeline to `front-door-pipeline.yaml`
* Remove all content, we will implement it from the IDE
* Save pipeline

![task-1-6](images/task-1-6.png)

* Optionally change commit message and `Save`

### Rename pipeline

![task-1-7](images/task-1-7.png)

* Navigate to `All`
* Select your newly created pipeline. It will have the same name as your Repository name
* Select `Rename/move`

![task-1-8](images/task-1-8.png)

* Set the new name, for example, `front-door`
* (Optional) Change folder
* Click `Save`

Now Azure DevOps committed new file into your repo and you can find it there.

 ![task-1-9](images/task-1-9.png)

Get this file to your local repo

```bash
git pull
```

![task-1-10](images/task-1-10.png)

Now when you have pipeline yaml file in local repo, you can work with it in VS Code.

## Task #2 - configure Front Door pipeline from the portal

For the Front Door resource we want  to have 100% automated pipeline and all changes done at thr ARM templates or scripts, should be immediately deployed. We don't need to publish templates and scripts as Azure DevOps artifacts because we can always trace back to git repo what was actually deployed. Therefore, we only need to configure:

* [trigger](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema#triggers) - specify when pipeline should start
* `az cli` task that will deploy Front Door ARM template

Here is the `trigger` configuration example

```yaml
trigger:
  branches:
    include:
    - master
  paths:
    include:
    - infrastructure/arm/02-front-door/*
```

It tells Azure DevOps that this pipeline should start when there is a change at any file under `infrastructure/arm/02-front-door/` in `master` branch.

Now let's get back to Azure DevOps and edit `front-door` pipeline

![task-2-1](images/task-2-1.png)

* In the edit window, add trigger section to the `front-door-pipelines.yml`.
* Add `steps:` element
* In `Tasks` list, type `az cli` and select `Azure CLI` task

![task-2-2](images/task-2-2.png)

### Configure Azure CLI task

![task-2-3](images/task-2-3.png)

* Select your Azure Service connection associated with your Azure Subscription
* Select `Script Type` as `Shell`
* Select `Script location` as `Script path`
* Set `Script path` to your Front Door deploy.sh script. If you follow our naming convention, it will be `infrastructure/arm/02-front-door/deploy.sh`
* Open `Advanced` section
* Set `Working Directory` to the folder, where front door deploy.sh script is located. If you follow our naming convention, it will be `infrastructure/arm/02-front-door/`
* Click `Add`

### Save pipeline

![task-2-4](images/task-2-4.png)

* Double check that everything looks correct and click `Save`

![task-2-5](images/task-2-5.png)

* Edit commit message if needed and click `Save`

### Pull changes to your local repo

```bash
git pull
```

## Task #2 - configure Front Door pipeline from the VS Code

If you don't what to click at the portal, you can edit your `front-door-pipeline.yaml` file and just paste this yaml into it

```yaml
trigger:
  branches:
    include:
    - master
  paths:
    include:
    - infrastructure/arm/02-front-door/*
steps:
- task: AzureCLI@2
  displayName: 'Deploy Front Door'
  inputs:
    azureSubscription: 'YOU-AZURE-DEVOPS-SERVICE-CONNECTION'
    scriptType: bash
    scriptPath: 'infrastructure/arm/02-front-door/deploy.sh'
    arguments: '$(Build.BuildNumber)'
    workingDirectory: 'infrastructure/arm/02-front-door'
```

Replace `YOU-AZURE-DEVOPS-SERVICE-CONNECTION` with your service connection. adjust `scriptPath` and `workingDirectory` if needed and push you changes.

```bash
git add .
git commit -m "Configuring front door pipeline"
git push
```

## Task #4 - run `front-door` pipeline

To run the pipeline, you can either find it at the pipeline list and click `Run pipeline` from the context menu

![task-4-1](images/task-4-1.png)

or, if you open pipeline, you can `Run pipeline` from there

![task-4-2](images/task-4-2.png)

You can optionally select from what branch you want to get source code form, select one and click `Run`

![task-4-3](images/task-4-3.png)

### Grant permission to Service Connection

Most likely you will be asked to grant permission for your pipeline to access `Service Connection`. Click `View``.

![task-4-4](images/task-4-4.png)

Then click `Permit`

![task-4-5](images/task-4-5.png)

 and `Permit`

![task-4-6](images/task-4-6.png)

After that pipeline will start and you can check the logs

![task-4-7](images/task-4-7.png)

## Task #5 - test CI trigger

Now test that trigger is configured properly.

* Change something at the Front Door ARM template
* Commit changes 

```bash
git add .
git commit -m "Testing CI trigger"
git push
```

and check that new build has started...

![task-5-1](images/task-5-1.png)

## Task #6 - commit and push any un-committed changes

```bash
git add .
git comment -m "Finish lab-07"
git push
```

## Checkpoint

Now we have `front-door` YAML based CI pipeline that automatically deploys Front Door changes.

You should have no changes at your repository

```bash
git status
...
nothing to commit, working tree clean
```

## Next

[Go to lab-08](../lab-08/readme.md)
