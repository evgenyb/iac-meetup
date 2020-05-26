# Lab-10 - create webapp release pipeline

CI/CD pipeline for our webapp will consists of 2 steps:

* build that will publish webapp static content as Azure DevOps artifacts
* release that will take build artifacts and deploys them to the selected environment

The gaol for this lab is to implement YAML based build pipeline

## Estimated completion time - x min

## Useful links

* [What is Azure Pipelines?](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops)
* [Use Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops)
* [Key concepts for new Azure Pipelines users](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops)
* [Artifacts in Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/artifacts/build-artifacts?view=azure-devops&tabs=yaml)

## Task #1 - create and configure `webapp` release pipeline

### Create new pipeline

![pic](images/task-1-1.png)

### We will configure it from scratch, therefore click `Empty job`

![pic](images/task-1-2.png)

### Give pipeline a name - `webapp` and add new artifact

![pic](images/task-1-3.png)

### Configure artifact

![pic](images/task-1-4.png)

* Use `Build` as a source type
* Select your Project
* Select your repo
* Set artifact alias to `artifacts`
* Click `Add`

### Configure continuous trigger

![pic](images/task-1-5.png)

* Click trigger icon
* Enable continuous deployment trigger
* Set branch to master

### Give the stage a name - `active`

![pic](images/task-1-6.png)

### Select agent pool configuration and add new task

![pic](images/task-1-7.png)

### Add Azure CLI task

![pic](images/task-1-8.png)

### Configure Azure CLI task

![pic](images/task-1-9.png)

* Set display name
* Select Azure Service Connection
* Set `Script type` to `Shell`
* Set `Script location` to `Script path`
* Set `Script path` to `$(System.DefaultWorkingDirectory)/artifacts/deploy/deploy-to-active.sh` (if you don't follow our convention, you may need to adjust the path)
* Set `Script Argument` to `$(System.DefaultWorkingDirectory)/artifacts/deploy/webapp` (if you don't follow our convention, you may need to adjust the path)
* Set `Working Directory` to `$(System.DefaultWorkingDirectory)/artifacts/deploy/` (if you don't follow our convention, you may need to adjust the path)

### Change release name format

![pic](images/task-1-10.png)

### Save and Create new release

## Task #3 - create new stage for `vNext` environment

### Open `webapp` release pipeline in Edit mode

![pic](images/task-2-0.png)

### Select `active` stage and Clone it

![pic](images/task-2-1.png)

### Set triggering mode to `Manual only`

We don't want to deploy to `vNext` environment automatically.

![pic](images/task-2-2.png)

### Change the name of the stage to `vNext`

![pic](images/task-2-3.png)

### Configure `Azure CLI` task

![pic](images/task-2-4.png)

Since we cloned it from already existing stage, we only need to change the name and deployment script.

* Change the name of the task
* Set `Script path` to `$(System.DefaultWorkingDirectory)/artifacts/deploy/deploy-to-vnext.sh` (if you don't follow our convention, you may need to adjust the path)
* Save the pipeline

## Task #3 - commit and push any un-committed changes

```bash
git add .
git comment -m "Finish lab-08"
git push
```

## Checkpoint

Now you should have release pipeline with 2 stages: `active` and `vNext`.

![pic](images/task-2-5.png)

You should have no changes at your repository

```bash
git status
...
nothing to commit, working tree clean
```

## Next

[Go to lab-11](../lab-11/readme.md)
