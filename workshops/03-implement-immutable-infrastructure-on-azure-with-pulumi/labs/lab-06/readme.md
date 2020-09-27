# lab-06 - working with configuration and secrets

## Estimated completion time - ?? min

Quite often, when you work with multiple environments, they will need a different set of configuration values. For instance, private virtual networks will use different address prefix, number of nodes and VM size in your AKS cluster most likely will be different.

Pulumi offers a configuration system for managing such differences. Instead of hard-coding the differences, you can store and retrieve configuration values using a combination of the CLI and the [programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/).

The key-value pairs for any given stack are stored in your project’s stack settings file called `Pulumi.<stack-name>.yaml`.

* The CLI offers a config command with set and get subcommands for managing key-value pairs.
* The programming model offers a `Config` object with various getters and setters for retrieving values.

## Goals

* Learn how to manage configuration and secrets using `CLI` and programming model.

## Useful links

* [Pulumi: programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/)
* [Pulumi: Configuration and Secrets](https://www.pulumi.com/docs/intro/concepts/config/)
* [pulumi config](https://www.pulumi.com/docs/reference/cli/pulumi_config/)
* [Pulumi: Config reference](https://www.pulumi.com/docs/intro/concepts/programming-model/#config)

## Task #1 - cerate new project for private virtual network

Let's implement private VNet `iac-lab07-vnet` with 2 subnets:

Subnet | address range
----|----
aks-net | 10.0.0.0/20
apim-net | 10.0.16.0/27

```bash
$ mkdir lab-07
$ cd lab-07
$ pulumi new azure-csharp
This command will walk you through creating a new Pulumi project.

Enter a value or leave blank to accept the (default), and press <ENTER>.
Press ^C at any time to quit.

project name: (lab-07)
project description: (A minimal Azure C# Pulumi program)
Created project 'lab-07'

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
        var resourceGroup = new ResourceGroup("iac-lab07-rg");

        var vnet = new VirtualNetwork("vnet", new VirtualNetworkArgs
        {
            Name = "iac-lab07-vnet",
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
 +   pulumi:pulumi:Stack              lab-07-dev    create
 +   ├─ azure:core:ResourceGroup      iac-lab07-rg  create
 +   ├─ azure:network:VirtualNetwork  vnet          create
 +   ├─ azure:network:Subnet          aks-net       create
 +   └─ azure:network:Subnet          apim-net      create

Resources:
    + 5 to create

Do you want to perform this update? yes
Updating (dev):
     Type                             Name          Status
 +   pulumi:pulumi:Stack              lab-07-dev    created
 +   ├─ azure:core:ResourceGroup      iac-lab07-rg  created
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
  lab-07:vnet.address: 10.0.0.0/16
  lab-07:vnet.subnets.apim-net: 10.0.16.0/27
  lab-07:vnet.subnets.aks-net: 10.0.0.0/20
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
        var resourceGroup = new ResourceGroup("iac-lab07-rg");

        var vnet = new VirtualNetwork("vnet", new VirtualNetworkArgs
        {
            Name = "iac-lab07-vnet",
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
     pulumi:pulumi:Stack  lab-07-dev

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
  lab-07:vnet.address: 10.1.0.0/16
  lab-07:vnet.subnets.apim-net: 10.1.16.0/27
  lab-07:vnet.subnets.aks-net: 10.1.0.0/20
```

Finally, deploy to prod

```bash
$ pulumi up
Previewing update (prod):
     Type                             Name          Plan
 +   pulumi:pulumi:Stack              lab-07-prod   create
 +   ├─ azure:core:ResourceGroup      iac-lab07-rg  create
 +   ├─ azure:network:VirtualNetwork  vnet          create
 +   ├─ azure:network:Subnet          aks-net       create
 +   └─ azure:network:Subnet          apim-net      create

Resources:
    + 5 to create

Do you want to perform this update? yes
Updating (prod):
     Type                             Name          Status
 +   pulumi:pulumi:Stack              lab-07-prod   created
 +   ├─ azure:core:ResourceGroup      iac-lab07-rg  created
 +   ├─ azure:network:VirtualNetwork  vnet          created
 +   ├─ azure:network:Subnet          apim-net      created
 +   └─ azure:network:Subnet          aks-net       created

Resources:
    + 5 created

Duration: 27s
```

## Task #4 - working with the secrets

Some configuration data is sensitive. Passwords or service tokens are good examples of such a data. For such cases, use `--secret` flag of the config set command will encrypt the data and instead of text will store the resulting ciphertext into the state.

TODO - Output and secrets

Stack outputs respect secret annotations and will also be encrypted appropriately. If a stack contains any secret values, their plaintext values will not be shown by default. Instead, they will be displayed as [secret] in the CLI. Pass --show-secrets to pulumi stack output to see the plaintext value.

## Task #5 - cleanup

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

[Go to lab-07](../lab-07/readme.md)
