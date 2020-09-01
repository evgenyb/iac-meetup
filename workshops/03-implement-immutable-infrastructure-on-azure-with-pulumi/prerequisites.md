# Prerequisites

## Laptop

Of course you need an laptop. OS installed at this laptop doesn't really matter. The tools we will use work cross platform. I will be using Windows 10 with PowerShell, but Pulumi cli works at all platforms (Windows, Linux, Mac).

## Microsoft Teams

Download and install [Microsoft Teams](https://products.office.com/en-US/microsoft-teams/group-chat-software)

## Visual Studio Code

Download and install VS Code. It's available for all platforms.
[Download Visual Studio Code](https://code.visualstudio.com/download)

I will be using [Pulumi for .NET Core C#](https://www.pulumi.com/docs/intro/languages/dotnet/), but if you prefer other [languages](https://www.pulumi.com/docs/intro/languages/), it should be no problem to follow. In that case, use your preferred language IDE.

## Create your Azure account

If you don't have an Azure account, please create one before the workshop.
[Create your Azure free account](https://azure.microsoft.com/en-us/free/?WT.mc_id=AZ-MVP-5003837)

## Create your Azure DevOps account

If you don't have an Azure DevOps, please create one before the workshop.
[Azure DevOps - start for free](https://azure.microsoft.com/en-gb/services/devops/?WT.mc_id=DOP-MVP-5003837)

## Create a new Project at Azure DevOps

Follow this [how-to guide](https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?WT.mc_id=DOP-MVP-5003837) and create a new project called `iac-ws-3`, or use an existing project, if you already have one.

## Create a new git repository

Create new git repository under your Azure DevOps project. Follow this [how-to guide](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-new-repo?WT.mc_id=DOP-MVP-5003837) and create a new repository called `iac-ws-3`.

## Check that you have access to Azure DevOps

Try to login to your Azure DevOps Account. Use some time and get yourself familiar with this product. During the workshop we will use the following features of this product:

* [Repos](https://docs.microsoft.com/en-gb/azure/devops/repos/get-started/what-is-repos?view=azure-devops&WT.mc_id=DOP-MVP-5003837) - here we will keep our source code
* [Pipelines](https://docs.microsoft.com/en-gb/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops&WT.mc_id=DOP-MVP-5003837) - all our build and release pipelines will be implemented here

## Clone your newly created repository to your laptop

Clone your repository to your PC. Make sure that your git environment is initialized and you can pull and push code from / to you repository. Add readme.md file, commit changes and push them to the remote.

## Learn git

If you have never worked with git, learn the git [commands basics](https://docs.gitlab.com/ee/gitlab-basics/start-using-git.html). You should be comfortable to clone, pull, commit and push your changes.

## Install `az cli`

Download and install latest version of `az cli` from this link  
[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest&WT.mc_id=AZ-MVP-5003837)

## Test your azure account with `az cli`

Open your terminal (bash, cmd or powershell) and login to your azure account by running this command

```bash
az login
```

You will be redirected to the browser where you will need to login with your azure account. Sometimes, you need to manually copy code and enter it at this page [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin). Just follow the instructions.

```bash
$ az login
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DMBKTZBJL to authenticate.
```

Set your active subscription.

```bash
az account set --subscription  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

or

```bash
az account set --subscription subscription_name
```

To get list of available subscriptions, use this command

```bash
az account list -o table
```

## Install `pulumi cli`

Download and install latest version of `pulumi cli` from this link  
[Installing Pulumi](https://www.pulumi.com/docs/get-started/install/)

### Useful links

* [Introducing Azure DevOps](https://azure.microsoft.com/en-us/blog/introducing-azure-devops/?WT.mc_id=DOP-MVP-5003837)
* [Introduction to Azure DevOps](https://www.youtube.com/watch?v=JhqpF-5E10I)
* [Pulumi - get Started with Azure](https://www.pulumi.com/docs/get-started/azure/)
* [Pulumi languages](https://www.pulumi.com/docs/intro/languages/)
* [Installing Pulumi](https://www.pulumi.com/docs/get-started/install/)