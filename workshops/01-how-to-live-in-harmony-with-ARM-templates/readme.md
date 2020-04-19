# This is the first workshop in the serious of hands-on workshops

At this workshop I will share some of my experience and tips & tricks on how I use ARM templates to implement complex infrastructure. You will learn how to use template functions to simplify multi-environment configuration, how to structure your ARM templates so it’s easy to work with them.

ARM template is not 100% user friendly, especially at the begging. I hope that after that workshop you will learn some of the tips and tricks that will help you to be calm and cool when working with ARM.

## Workshop structure

Workshop will consists of some theoretical part (very little) and labs. We will start with creating resource groups and azure portal dashboard.
Then we will implement simple infrastructure component that consists of 2 network security groups and one private virtual network with 2 subnets.
And all remaining labs will be a set of refactoring tasks that will help us to improve out ARM templates and make them easy to maintain, update and introduce new environments.
The reason I choose nsg and vnet as resources for the labs is because it takes very little time to provision them and since we will do a lot of refactoring, we will need to re-deploy them frequently.

## Hint #1 for the workshop

If you stack with implementing ARM template either because you are not familiar with the resources we will use during the workshop or because it's not that obvious from the documentation reference what property or parameter to use, feel free to implement that is described at the lab from the portal and then just export ARM template and see how it should actually be implemented. You can find `Export template` option at the right side menu.  

This is in fact the fastest way to learn how to implement ARM template, especially for complex resources cush as VM, ApplicationGateways, APIM etc...

## Hint #2 for the workshop

Alternative option to learn ARM templates is to check the [Azure Quickstart Templates ](https://github.com/Azure/azure-quickstart-templates). Just search for the resource you want to implement and most likely you will find it there.

For our workshop these 2 are very much relevant:
* [Create a Network Security Group](https://github.com/Azure/azure-quickstart-templates/tree/master/101-security-group-create)

* [Virtual Network with two Subnets](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vnet-two-subnets)

## Prerequisites

### Laptop

Of course you need an laptop. OS installed at this laptop doesn't really matter. The tools we will use work cross platform. I will be using Windows 10 with ubuntu (WSL) as a shell.

### Microsoft Teams

Download and install [Microsoft Teams](https://products.office.com/en-US/microsoft-teams/group-chat-software)

### Visual Studio Code

Please download and install VS Code. It's available for all platforms.
[Download Visual Studio Code](https://code.visualstudio.com/download)

### Azure Resource Manager (ARM) Tools plugin for VS Code

Install plugin from [marketplace](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools) 

### Create your Azure account

If you don't have an Azure account, please create one before the workshop.
[Create your Azure free account](https://azure.microsoft.com/en-us/free/)

### Install `az cli`

Download and install latest version of `az cli` from this link  
[Install the Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

### Test your azure account with `az cli`

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
az account set --subscription       xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

or

```bash
az account set --subscription subscription_name
```

To check what is the current active subscription, use this command

```bash
az account show
```

## Links

[Azure Resource Manager overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)

[Azure Resource Manager templates overview](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/overview)

[Understand the structure and syntax of Azure Resource Manager templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-syntax)

[Tutorial: Create and deploy your first Azure Resource Manager template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-create-first-template?tabs=azure-cli)

[ARM template functions](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates)

[ARM template REST](https://docs.microsoft.com/en-us/rest/api/resources/#rest-operation-groups)

[Network Security Group template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-11-01/networksecuritygroups)

[Virtual networks template reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-11-01/virtualnetworks)

[Using linked and nested templates when deploying Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates)
