# lab-07 - working with configuration and secrets

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

Let's introduce the following config values:

Key | Value
----|----
vnet.address | 10.0.0.0/16
vnet.subnets.ask-net | 10.0.0.0/20
vnet.subnets.ask-net | 10.0.16.0/27


## Next: managing secrets with Azure Key-Vault

[Go to lab-08](../lab-08/readme.md)