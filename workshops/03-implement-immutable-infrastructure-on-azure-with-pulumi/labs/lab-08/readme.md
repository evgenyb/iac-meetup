# lab-08 - import existing resources

## Estimated completion time - ?? min

Most likely, when you start adapting Pulumi in your project, there will be quite a lot of existing infrastructure already provisioned and then you to import existing resources so they can be managed by Pulumi.

To adopt existing resources so that Pulumi is able to manage subsequent updates to them, Pulumi offers the import resource option. This option requests that a resource defined in your Pulumi program adopts an existing resource in Azure instead of creating a new one.

## Goals

* Learn how you can import existing resources into Pulumi stack

## Useful links

* [Pulumi import](https://www.pulumi.com/docs/intro/concepts/programming-model/#import)
* [Pulumi: VirtualNetwork reference](https://www.pulumi.com/docs/reference/pkg/azure/network/virtualnetwork/)
* [Pulumi: Subnet reference](https://www.pulumi.com/docs/reference/pkg/azure/network/subnet/)
* [Import existing Azure DNS Zone into Pulumi](https://borzenin.com/import-dns-zone-into-pulumi/)
* [Visual Subnet Calculator](http://www.davidc.net/sites/default/subnets/subnets.html)
* [Virtual Network documentation](https://docs.microsoft.com/en-us/azure/virtual-network/?WT.mc_id=AZ-MVP-5003837)
* [Manage Azure Resource Manager resource groups by using the Azure portal](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal?WT.mc_id=AZ-MVP-5003837)
* [Azure Command-Line Interface (CLI) documentation](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest&WT.mc_id=AZ-MVP-5003837)
* [Azure PowerShell Az](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az?view=azps-4.6.1&WT.mc_id=AZ-MVP-5003837)

## Task #1 - create new resource group and private virtual Vnet

First, let's manually create some resources that we will import into Pulumi. Create 2 resources:

* Resource group called `iac-lab08-rg`
* private virtual network (further VNet) called `iac-pulumi-import-vnet` with 3 subnets. 

Subnet | Range
----|----
aks|10.0.0.0/24
agw|10.0.1.0/24
apim|10.0.2.0/24

Use portal, `az cli` or Powershell to create resources. I will use `az cli`.

```bash
$ az group create -n iac-lab08-rg -l norwayeast
$ az network vnet create -n iac-pulumi-import-vnet -g iac-lab08-rg --address-prefixes 10.0.0.0/16
$ az network vnet subnet create -n aks  --vnet-name iac-pulumi-import-vnet -g iac-lab08-rg --address-prefixes 10.0.0.0/24
$ az network vnet subnet create -n agw  --vnet-name iac-pulumi-import-vnet -g iac-lab08-rg --address-prefixes 10.0.1.0/24
$ az network vnet subnet create -n apim  --vnet-name iac-pulumi-import-vnet -g iac-lab08-rg --address-prefixes 10.0.2.0/24
```

## Task #2 - create new Pulumi project

```bash
$ mkdir lab-08
$ cd lab-08
$ pulumi new azure-csharp
```

Remove storage account resource definition code.

## Task #3 - identify resource ID for resource we wan to import into Pulumi

First thing we need to do before we start importing existing resources into Pulumi, is to find Azure resource IDs. You can find this information at the Properties page at the Azure portal, use [az cli](https://docs.microsoft.com/en-us/cli/azure/?view=azure-cli-latest&WT.mc_id=AZ-MVP-5003837) or [Azure PowerShell Az](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az?view=azps-4.6.1&WT.mc_id=AZ-MVP-5003837) module.

Get resource group ID

```bash
$ az group show --name iac-lab08-rg --query id
"/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/iac-lab08-rg"
```

Get VNet and subnets IDs

```bash
$ az network vnet show --vnet-name iac-pulumi-import-vnet -g iac-lab08-rg
```

## Task #4 - import resource group

With ID in place, we implement the regular Pulumi stack, but in addition to normal resource specification, we use `CustomResourceOptions` class and set `ImportId` to resource ID for each of the resources we want to import.

Here is how we import Resource Group.

Note! You should use your own resource IDs.

```c#
var resourceGroup = new ResourceGroup("rg", new ResourceGroupArgs
{
    Name = "iac-lab08-rg",
    Location = "norwayeast",

}, new CustomResourceOptions
{
    ImportId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/iac-lab08-rg"
});
```

If you run `pulumi up` now you will see  

```bash
$ pulumi up
Previewing update (dev)

     Type                         Name        Plan       
 +   pulumi:pulumi:Stack          lab-08-dev  create     
 =   └─ azure:core:ResourceGroup  rg          import     
 
Resources:
    + 1 to create
    = 1 to import
    2 changes

Do you want to perform this update? yes
Updating (dev)

     Type                         Name        Status       
 +   pulumi:pulumi:Stack          lab-08-dev  created      
 =   └─ azure:core:ResourceGroup  rg          imported     
 
Resources:
    + 1 created
    = 1 imported
    2 changes

Duration: 11s
```

## Task #5 - import Vnet

Now, use the same technique and import the private vNet `iac-pulumi-import-vnet` with 3 subnets. Here is the code sample.

Note! You should use your own resource IDs.

```c#
...
var vnet = new VirtualNetwork("vnet", new VirtualNetworkArgs
{
    ResourceGroupName = resourceGroup.Name,
    Location = resourceGroup.Location,
    Name = "iac-pulumi-import-vnet",
    AddressSpaces = 
    {
        { "10.0.0.0/16" }
    }
}, new CustomResourceOptions
{
    ImportId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/iac-lab08-rg/providers/Microsoft.Network/virtualNetworks/iac-pulumi-import-vnet"
});

var aksSubNet = new Subnet("aks", new SubnetArgs
{
    Name = "aks",
    ResourceGroupName = resourceGroup.Name,
    VirtualNetworkName = vnet.Name,
    AddressPrefixes = "10.0.0.0/24"
}, new CustomResourceOptions
{
    ImportId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/iac-lab08-rg/providers/Microsoft.Network/virtualNetworks/iac-pulumi-import-vnet/subnets/aks"
});
...
```

When you run `pulumi up`, you should see similar result

```bash
$ pulumi up
Previewing update (dev)

     Type                             Name        Plan       
     pulumi:pulumi:Stack              lab-08-dev             
 =   ├─ azure:network:VirtualNetwork  vnet        import     
 =   ├─ azure:network:Subnet          agw         import     
 =   ├─ azure:network:Subnet          apim        import     
 =   └─ azure:network:Subnet          aks         import     
 
Resources:
    = 4 to import
    2 unchanged

Do you want to perform this update? yes
Updating (dev)

     Type                             Name        Status       
     pulumi:pulumi:Stack              lab-08-dev               
 =   ├─ azure:network:VirtualNetwork  vnet        imported     
 =   ├─ azure:network:Subnet          apim        imported     
 =   ├─ azure:network:Subnet          agw         imported     
 =   └─ azure:network:Subnet          aks         imported     
 
Resources:
    = 4 imported
    2 unchanged

Duration: 10s
```

## Task #5 - cleanup

Destroy resources

```bash
$ pulumi destroy --yes
```

## Next: 

[Go to lab-09](../lab-09/readme.md)