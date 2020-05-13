# Prerequisites

## Complete all labs from workshop #1

You should complete all labs from [workshop #1](../01-how-to-live-in-harmony-with-ARM-templates/agenda.md). This is important because we will use a lot of techniques introduced during that workshop, so, please invest some time (you need approx. 4-5 hours) and go through the [labs](../01-how-to-live-in-harmony-with-ARM-templates/agenda.md).

## Laptop

Of course you need an laptop. OS installed at this laptop doesn't really matter. The tools we will use work cross platform. I will be using Windows 10 with ubuntu (WSL) as a shell.

## Microsoft Teams

Download and install [Microsoft Teams](https://products.office.com/en-US/microsoft-teams/group-chat-software)

## Visual Studio Code

Please download and install VS Code. It's available for all platforms.
[Download Visual Studio Code](https://code.visualstudio.com/download)

## Azure Resource Manager (ARM) Tools plugin for VS Code

Install plugin from [marketplace](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools) 

## Create your Azure account

If you don't have an Azure account, please create one before the workshop.
[Create your Azure free account](https://azure.microsoft.com/en-us/free/)

## Create your Azure DevOps account

If you don't have an Azure DevOps, please create one before the workshop.
[Azure DevOps - start for free](https://azure.microsoft.com/en-gb/services/devops/)

## Install `az cli`

Download and install latest version of `az cli` from this link  
[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

## Install `az front-door` extension

```bash
az extension add -n front-door
```

Check that it was installed

```bash
az network front-door --help
```

## Install `az devops` extension (optional)

```bash
az extension add -n azure-devops
```

Check that it was successfully installed

```bash
az devops --help
```

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

Next (and this step is optional), you need to set your active subscription.
To get list of available subscriptions, use this command

```bash
az account list -o table
```

Note, The `-o table` or `--output table` parameter switches the output to a more concise human-readable format.

To set subscription use this command. You can use both subscription id or subscription name as value for `--subscription` argument.

```bash
az account set --subscription  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

or

```bash
az account set --subscription subscription_name
```
