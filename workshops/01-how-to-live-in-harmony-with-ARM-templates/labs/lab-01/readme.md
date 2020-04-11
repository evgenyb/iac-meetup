# Lab-01 - initialize environment and create resource groups

The goals for this lab are:

* initialize your `az cli` environment
* create 2 resource groups for `dev` and `prod` environments
* create Azure portal dashboard at the portal

 Also, please check our [naming conventions](../../naming-conventions.md) before  you start.

## Task #1 - initialize `az cli` environment

Fist, you need to login to your azure account

```bash
$ az login
```

You will be redirected to the browser where you will need to login with your azure account. Sometimes, you need manually copy code and enter it at this page [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin). Just follow the instructions.

```bash
$ az login
To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DMBKTZBJL to authenticate.
```

Next (and this step is optional), you need to set your active subscription.
To get list of available subscriptions, use this command

```bash
$ az account list
```

To set subscription use this command. You can use both subscription id and subscription name as value for `--subscription` argument.

```bash
$ az account set --subscription 5d541385-7526-4b12-bf15-69857e9b21c4
or
$ az account set --subscription evgeny.borzenin

```


## Tips

Every time you don't remember what `az` commands available or what are the arguments for the selected command, you can add `--help` attribute to get help. Here are some examples:

```bash
# Show list of all commands available
az --help

# Show list of subgroups and commands available under the group `resource`
az group --help

# Show list of arguments available for create resource group command
az group create --help
```

az cli support auto completion, just start typing command and press `Tab` and if command exists, it will be auto completed.

If you double `Tab`, az cli will show you list of commands or arguments available at the current context, sort of light version of `--help` flag.

## Task #2

Create resource group for `dev` environment.

```bash
az group create -n iac-dev-rg -l westeurope --tags owner=team-platform env=dev description="Workshop #1 resources for dev environment"
```

## Task #3

Create resource group for `prod` environment.

```bash
az group create -n iac-prod-rg -l westeurope --tags owner=team-platform env=prod description="Workshop #1 resources for production environment"
```

## Task #4

Create Azure portal dashboard for newly created resource groups.

Go to [Azure portal](https://portal.azure.com/) and create new dashboard followed by the [following instructions](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-dashboards). Let's call this dashboard `IaC Lab #1`. 

Find resource group `iac-dev-rg` and pin it to the dashboard by clicking pin icon ![pin](img/pin.png) at the top right corner of resource group window next to the close icon ![close](img/close.png).

Find resource group `iac-prod-rg` and pin it to the dashboard by clicking pin icon ![pin](img/pin.png) at the top right corner of resource group window next to the close icon ![close](img/close.png).

After you successfully done this, your dashboard should like this:

![dashboard](img/dashboard.png)