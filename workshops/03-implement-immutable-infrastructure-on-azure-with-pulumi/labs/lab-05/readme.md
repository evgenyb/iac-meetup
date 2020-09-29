# lab-05 - working with configuration and secrets

## Estimated completion time - 15-20 min

Quite often, when you work with multiple environments, they use a different set of configuration values. For instance, private virtual networks will use different address prefix, number of nodes and VM size at your AKS clusters most likely will be different.

Pulumi offers a configuration system for managing such differences. Instead of hard-coding the values, you can store and retrieve configuration values using a combination of the CLI and the [programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/).

The key-value pairs for any given stack are stored in your project’s stack settings file called `Pulumi.<stack-name>.yaml`.

* The CLI offers a `config` command with `set` and `get` subcommands for managing key-value pairs.
* The programming model offers a `Config` class with various getters and setters for retrieving values.

## Goals

* Learn how to manage configuration and secrets using `CLI` and programming model.

## Useful links

* [Pulumi: programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/)
* [Pulumi: Configuration and Secrets](https://www.pulumi.com/docs/intro/concepts/config/)
* [pulumi config](https://www.pulumi.com/docs/reference/cli/pulumi_config/)
* [Pulumi: Config reference](https://www.pulumi.com/docs/intro/concepts/programming-model/#config)

## Task #1 - cerate new project for private virtual network

Let's implement private VNet `iac-lab05-vnet` with 2 subnets:

Subnet | address range
----|----
aks-net | 10.0.0.0/20
apim-net | 10.0.16.0/27

```bash
$ mkdir lab-05
$ cd lab-05
$ pulumi new azure-csharp
This command will walk you through creating a new Pulumi project.

Enter a value or leave blank to accept the (default), and press <ENTER>.
Press ^C at any time to quit.

project name: (lab-05)
project description: (A minimal Azure C# Pulumi program)
Created project 'lab-05'

stack name: (dev)
Created stack 'dev'

azure:location: The Azure location to use: (WestUS) westeurope
Saved config

Installing dependencies...
```

Feel free to implement it yourself or use the following code snippet.

```c#
using Pulumi;
using Pulumi.Azure.Core;
using Pulumi.Azure.Network;

class MyStack : Stack
{
    public MyStack()
    {
        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs {
            Name = $"iac-lab05-{Deployment.Instance.StackName}-rg"
        });

        var vnet = new VirtualNetwork("vnet", new VirtualNetworkArgs
        {
            Name = "iac-lab05-vnet",
            ResourceGroupName = resourceGroup.Name,
            AddressSpaces = { "10.0.0.0/16" }
        });

        var aksSubnet = new Subnet("aks-net", new SubnetArgs{
            Name = "aks-net",
            ResourceGroupName = resourceGroup.Name,
            VirtualNetworkName = vnet.Name,
            AddressPrefixes = {"10.0.0.0/20"}
        });

        var apimSubnet = new Subnet("apim-net", new SubnetArgs{
            Name = "apim-net",
            ResourceGroupName = resourceGroup.Name,
            VirtualNetworkName = vnet.Name,
            AddressPrefixes = {"10.0.16.0/27"}
        });
    }
}
```

Deploy it

```bash
$ pulumi up
Previewing update (dev):
     Type                             Name          Plan
 +   pulumi:pulumi:Stack              lab-05-dev    create
 +   ├─ azure:core:ResourceGroup      iac-lab05-rg  create
 +   ├─ azure:network:VirtualNetwork  vnet          create
 +   ├─ azure:network:Subnet          aks-net       create
 +   └─ azure:network:Subnet          apim-net      create

Resources:
    + 5 to create

Do you want to perform this update? yes
Updating (dev):
     Type                             Name          Status
 +   pulumi:pulumi:Stack              lab-05-dev    created
 +   ├─ azure:core:ResourceGroup      iac-lab05-rg  created
 +   ├─ azure:network:VirtualNetwork  vnet          created
 +   ├─ azure:network:Subnet          aks-net       created
 +   └─ azure:network:Subnet          apim-net      created

Resources:
    + 5 created

Duration: 36s
```

## Task #2 - extract vnet and subnet address values into Pulumi configuration

Having IP address values in the code only will work if there is only one environment. If there are more than one, we need to extract them into the stack's settings file representing the environment.

Let's introduce the following config values:

Key | Value
----|----
vnet.address | 10.0.0.0/16
vnet.subnets.aks-net | 10.0.0.0/20
vnet.subnets.apim-net | 10.0.16.0/27

```bash
$ pulumi config set vnet.address '10.0.0.0/16'
$ pulumi config set vnet.subnets.aks-net '10.0.0.0/20'
$ pulumi config set vnet.subnets.apim-net '10.0.16.0/27'
```

If you check your `Pulumi.dev.yaml` file, you will find 3 new config items. 

```bash
$ cat Pulumi.dev.yaml
...
config:
  azure:location: westeurope
  lab-05:vnet.address: 10.0.0.0/16
  lab-05:vnet.subnets.apim-net: 10.0.16.0/27
  lab-05:vnet.subnets.aks-net: 10.0.0.0/20
```

Now, in the code we should use [Config](https://www.pulumi.com/docs/intro/concepts/programming-model/#config) class and programmatically read address range values from the configuration. Configuration values can be retrieved using either `Config.Get` or `Config.Require` methods. Using `Config.Get` will return `null` if the configuration value was not provided, and `Config.Require` will raise an exception to prevent the deployment from continuing until the variable has been set using the CLI.

Now, let's refactor our code to use `Config` class. Here is my implementation.

```c#
class MyStack : Stack
{
    public MyStack()
    {
        var config = new Config();

        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs {
            Name = $"iac-lab05-{Deployment.Instance.StackName}-rg"
        });

        var vnet = new VirtualNetwork("vnet", new VirtualNetworkArgs
        {
            Name = "iac-lab05-vnet",
            ResourceGroupName = resourceGroup.Name,
            AddressSpaces = { config.Require("vnet.address") }
        });

        var aksSubnet = new Subnet("aks-net", new SubnetArgs{
            Name = "aks-net",
            ResourceGroupName = resourceGroup.Name,
            VirtualNetworkName = vnet.Name,
            AddressPrefixes = { config.Require("vnet.subnets.aks-net") }
        });

        var apimSubnet = new Subnet("apim-net", new SubnetArgs{
            Name = "apim-net",
            ResourceGroupName = resourceGroup.Name,
            VirtualNetworkName = vnet.Name,
            AddressPrefixes = { config.Require("vnet.subnets.apim-net") }
        });
    }
}
```

Deploy the stack and there should be no changes

```bash
$ pulumi up
Previewing update (dev):
     Type                 Name        Plan
     pulumi:pulumi:Stack  lab-05-dev

Resources:
    5 unchanged
```

## Task #3 - add `prod` stack

Now, let's add new `prod` stack that will represent our production environment.

```bash
$ pulumi stack init -s prod
Created stack 'prod'
```

Next, add vnet address range values for the `prod` environment

```bash
$ pulumi config set vnet.address '10.1.0.0/16'
$ pulumi config set vnet.subnets.aks-net '10.1.0.0/20'
$ pulumi config set vnet.subnets.apim-net '10.1.16.0/27'
$ pulumi config set azure:location northeurope
```

Note, when you `init` new stack with Azure provider, it doesn't ask you for the stack location, therefore we needed to add `azure:location` key.

If you check your `Pulumi.prod.yaml` file, you will find 3 new config items.

```bash
$ cat Pulumi.prod.yaml
...
config:
  azure:location: northeurope
  lab-05:vnet.address: 10.1.0.0/16
  lab-05:vnet.subnets.apim-net: 10.1.16.0/27
  lab-05:vnet.subnets.aks-net: 10.1.0.0/20
```

Finally, deploy to prod

```bash
$ pulumi up
Previewing update (prod):
     Type                             Name          Plan
 +   pulumi:pulumi:Stack              lab-05-prod   create
 +   ├─ azure:core:ResourceGroup      iac-lab05-rg  create
 +   ├─ azure:network:VirtualNetwork  vnet          create
 +   ├─ azure:network:Subnet          aks-net       create
 +   └─ azure:network:Subnet          apim-net      create

Resources:
    + 5 to create

Do you want to perform this update? yes
Updating (prod):
     Type                             Name          Status
 +   pulumi:pulumi:Stack              lab-05-prod   created
 +   ├─ azure:core:ResourceGroup      iac-lab05-rg  created
 +   ├─ azure:network:VirtualNetwork  vnet          created
 +   ├─ azure:network:Subnet          apim-net      created
 +   └─ azure:network:Subnet          aks-net       created

Resources:
    + 5 created

Duration: 27s
```

## Task #4 - working with the secrets

Some configuration data is sensitive. Passwords or service tokens are good examples of such a data. For such cases, `--secret` flag of the `config set` command will encrypt the data and instead of text it will store the resulting ciphertext into the state.

Stack outputs respect secret annotations and will also be encrypted appropriately. If a stack contains any secret values, their plaintext values will not be shown by default. Instead, they will be displayed as [secret] in the CLI. Pass `--show-secrets` to Pulumi stack output to see the plaintext value.

Let's add new tag `foo` with value `bar` to the resource group and deploy change

```c#
var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs {
    Name = $"iac-lab05-{Deployment.Instance.StackName}-rg",
    Tags = {
        { "foo", "bar"}
    }
});
```

```bash
$ pulumi up --yes
```

check that tag was added

```bash
$ az group show -n iac-lab05-prod-rg
{
  ...
  "tags": {
    "foo": "bar"
  },
  ...
}
```

Now, lets add new configuration secret `foo` with value `bar` 

```bash
$ pulumi config set foo bar --secret
```

check the `Pulumi.prod.yaml` file 

```bash
$ cat Pulumi.prod.yaml
config:
  azure:location: northeurope
  lab-05:foo:
    secure: v1:EitXVz5/Pr8MyJnq:xoi9/4ak83xEYU62oOkdAk5qFg==
  lab-05:vnet.address: 10.1.0.0/16
  lab-05:vnet.subnets.aks-net: 10.1.0.0/20
  lab-05:vnet.subnets.apim-net: 10.1.16.0/27
```

as you can see, the `foo` was added as encrypted secret.

Now, lets use if from the code. 

```c#
var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs {
    Name = $"iac-lab05-{Deployment.Instance.StackName}-rg",
    Tags = {
        { "foo", config.Require("foo") }
    }
});
```

Now, instead of hard coding the `bar` value, we read it from the configuration. If you deploy now, there will be no changes, because the value has not changed.

If we check the state, we can find that Tags are stored as a clear text in the state

```bash
$ pulumi state export

...
"tags": {
    "__defaults": [],
    "foo": "bar"
}
...
```

Now, change the code and use `config.RequreSecret` instead of `config.Requre` and deploy

```c#
var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs {
    Name = $"iac-lab05-{Deployment.Instance.StackName}-rg",
    Tags = {
        { "foo", config.RequireSecret("foo") }
    }
});
```

There will be no changes to the resources, but if you check the state, the Tags section is now encrypted...

```bash
$ pulumi stack export

...
"tags": {
    "4dabf18193072939515e22adb298388d": "1b47061264138c4ac30d75fd1eb44270",
    "ciphertext": "v1:BCnLl13WqOKuzuJ3:bIu4z+piYB1UNR6AT6BJEomfm3BD3hlmhSrTsKvH2Xvbd7dhR3WfZIynI15T"
}
...
```

## Task #6 - cleanup

Destroy resources and remove `prod` stack

```bash
$ pulumi destroy -s prod
$ pulumi stack rm prod
```

Destroy resources and remove `dev` stack

```bash
$ pulumi destroy -s dev
$ pulumi stack rm dev
```

## Next: managing secrets with Azure Key-Vault

[Go to lab-06](../lab-06/readme.md)
