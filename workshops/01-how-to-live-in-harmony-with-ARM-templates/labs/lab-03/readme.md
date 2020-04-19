# lab-03 - provisioning of 2 Network Security Groups and one private virtual network

## Task #1 - Network Security Group for AGW subnet

Create ARM template for Network Security Group called `iac-dev-agw-nsg` with 3 rules:

```txt
name: INT-T443-IN-ALLOW
description: ""
protocol: Tcp
sourcePortRange: *
destinationPortRange: 443
sourceAddressPrefix: Internet
destinationAddressPrefix: 10.112.16.128/25
access: Allow
priority: 100
direction: Inbound

name: INT-T80-IN-ALLOW
description: ""
protocol: Tcp
sourcePortRange: *
destinationPortRange: 80
sourceAddressPrefix: Internet
destinationAddressPrefix: 10.112.16.128/25
access: Allow
priority: 101
direction: Inbound

name: AKS-T443-OUT-ALLOW
description: ""
protocol: Tcp
sourcePortRange: *
destinationPortRange: 443
sourceAddressPrefix: 10.112.16.128/25
destinationAddressPrefix: 10.112.16.128/25
access: Allow
priority: 10
direction: Outbound
```

Use the following
[ARM template reference for Network Security Group](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-11-01/networksecuritygroups) to learn more about Network Security Group resource properties.

Validate template

```bash
az group deployment validate --template-file template.json -g iac-dev-rg
```

Deploy ARM template

```bash
az group deployment create -g iac-dev-rg --template-file template.json
```

## Task #2 - create Network Security Group for AKS subnet

Create ARM template for Network Security Group called `iac-dev-aks-nsg` with 1 rule:

```txt
name: AGW-T443-IN-ALLOW
description: ""
protocol: Tcp
sourcePortRange: *
destinationPortRange: 443
sourceAddressPrefix: 10.112.16.128/25
destinationAddressPrefix: 10.112.16.128/25
access: Allow
priority: 100
direction: Inbound
```

Validate template

```bash
az group deployment validate --template-file template.json -g iac-dev-rg
```

Deploy ARM template

```bash
az group deployment create -g iac-dev-rg --template-file template.json
```

## Task #3 - create new private Virtual Network

Create ARM template for private Virtual Network called `iac-dev-vnet` with 2 subnets and the following specifications:

```txt
VNet name: iac-dev-vnet
addressPrefix: 10.112.0.0/16

Subnets:
    name: aks-net
    addressPrefix: 10.112.0.0/20
    networkSecurityGroup.id: iac-dev-aks-nsg

    name: agw-net
    addressPrefix: 10.112.16.128/25
    networkSecurityGroup.id: iac-dev-agw-nsg
```

Use the following
[ARM template reference for virtual Networks](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2019-11-01/virtualnetworks) to learn more about virtual Networks resource properties.

### Hint #1

Our subnet uses network security group that are described at the same template, therefore we should specify nsg resources as dependencies of vnet resource. Read more about [how to define the order for deploying resources in ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/define-resource-dependency)  

### Hint #2

To specify `nsg` for subnet definition, use `networkSecurityGroup` property an set `id` field by using `resourceId` function. Read more about [resourceId function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#resourceid)

Validate template

```bash
az group deployment validate --template-file template.json -g iac-dev-rg
```

Deploy ARM template

```bash
az group deployment create -g iac-dev-rg --template-file template.json
```

## Task #4 (optional) - find an error in AKS-T443-OUT-ALLOW and AGW-T443-IN-ALLOW rules, fix it and deploy templates

## Checkpoint

* You should have one ARM template with 3 resources
* You should see (at least) 3 deployments at the resource groups level

## Useful links

* [ARM 101: Create a Network Security Group](https://github.com/Azure/azure-quickstart-templates/tree/master/101-security-group-create)

* [ARM 101: Virtual Network with two Subnets](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vnet-two-subnets)

## Next

[Go to lab-04](../lab-04/readme.md)
