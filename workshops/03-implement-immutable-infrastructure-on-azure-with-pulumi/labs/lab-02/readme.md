# lab-02 - working with pulumi "flow"

## Estimated completion time - ?? min

## Goals

* Learn Pulumi CLI commands and how to use them to control lifecycle of the resources

## Task #1 - preview of updates to a stack’s resources

To show a preview of updates run the following command

```bash
$ pulumi preview
Previewing update (dev)

     Type                         Name              Plan       
 +   pulumi:pulumi:Stack          iac-ws-infra-dev  create     
 +   └─ azure:core:ResourceGroup  resourceGroup     create     
 
Resources:
    + 2 to create
```

From [documentation](https://www.pulumi.com/docs/reference/cli/pulumi_preview/)
> This command displays a preview of the updates to an existing stack whose state is represented by an existing state file. The new desired state is computed by running a Pulumi program, and extracting all resource allocations from its resulting object graph. These allocations are then compared against the existing state to determine what operations must take place to achieve the desired state. No changes to the stack will actually take place.

If you want to display operation as a rich diff showing the overall change, use `--diff` flag

```bash
$ pulumi preview --diff
Previewing update (dev)
...
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:dev::iac-ws-infra::pulumi:pulumi:Stack::iac-ws-infra-dev]
    + azure:core/resourceGroup:ResourceGroup: (create)
        [urn=urn:pulumi:dev::iac-ws-infra::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::iac-ws-infra::pulumi:providers:azure::default_3_20_1::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
        location  : "westeurope"
        name      : "resourcegroup5713ee5b"
Resources:
    + 2 to create
```

## Task #2 - deploy the stack

Now, let's deploy the stack:

```bash
$ pulumi up
```

The first thing this command does it shows a preview of the changes that will be made (similar to `pulumi preview`):

```bash
$ pulumi up
Previewing update (dev)

     Type                         Name              Plan       
 +   pulumi:pulumi:Stack          iac-ws-infra-dev  create     
 +   └─ azure:core:ResourceGroup  resourceGroup     create     
 
Resources:
    + 2 to create

Do you want to perform this update?  [Use arrows to move, enter to select, type to filter]
  yes
> no
  details
```

Choosing `details` will display a rich diff showing the overall change (similar to `pulumi preview --diff`):

```bash
$ pulumi up
Previewing update (dev)
     Type                         Name              Plan       
 +   pulumi:pulumi:Stack          iac-ws-infra-dev  create     
 +   └─ azure:core:ResourceGroup  resourceGroup     create     
 
Resources:
    + 2 to create

Do you want to perform this update? details
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:dev::iac-ws-infra::pulumi:pulumi:Stack::iac-ws-infra-dev]
    + azure:core/resourceGroup:ResourceGroup: (create)
        [urn=urn:pulumi:dev::iac-ws-infra::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::iac-ws-infra::pulumi:providers:azure::default_3_20_1::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
        location  : "westeurope"
        name      : "resourcegroupbecc89f0"

Do you want to perform this update?  [Use arrows to move, enter to select, type to filter]
  yes
> no
  details
```

Choosing `yes` will create resources in Azure.

```bash
Do you want to perform this update? yes
Updating (dev)

View Live: https://app.pulumi.com/evgenyb/iac-ws-infra/dev/updates/1

     Type                         Name              Status      
 +   pulumi:pulumi:Stack          iac-ws-infra-dev  created     
 +   └─ azure:core:ResourceGroup  resourceGroup     created     
 
Resources:
    + 2 created

Duration: 11s
```

## Task #3 - modify your resources and deploy changes

Now, let's make some modifications to our resources, for example, add Tags.

```c#
public MyStack()
{
    // Create an Azure Resource Group
    var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs
    {
        Tags = 
        {
            {"Owner", "team-platform"},
            {"Environments", Deployment.Instance.StackName },
        }
    });
}
```

Deploy changes

```bash
$ pulumi up
Previewing update (dev)

     Type                         Name              Plan       Info
     pulumi:pulumi:Stack          iac-ws-infra-dev             
 ~   └─ azure:core:ResourceGroup  resourceGroup     update     [diff: ~tags]
 
Resources:
    ~ 1 to update
    1 unchanged

Do you want to perform this update? details
  pulumi:pulumi:Stack: (same)
    [urn=urn:pulumi:dev::iac-ws-infra::pulumi:pulumi:Stack::iac-ws-infra-dev]
    ~ azure:core/resourceGroup:ResourceGroup: (update)
        [id=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourcegroupb965cf3b]
        [urn=urn:pulumi:dev::iac-ws-infra::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::iac-ws-infra::pulumi:providers:azure::default_3_20_1::61ad2ddb-15cf-4ed6-9d87-23f962ba0128]
      ~ tags: {
          + Environments: "dev"
          + Owner       : "team-platform"
        }

Do you want to perform this update?  [Use arrows to move, enter to select, type to filter]
  yes
> no
  details
```

Pulumi will update the resource group to add two tags. Note, we can read current stack name from the `Deployment.Instance.StackName` property.

Choosing `yes` will proceed with the update.

## Task #5 - destroy resources

Quite often you need to remove all components included into your infrastructure. To clean up and tear down the resources that are part of our stack, run the following command:

```bash
$ pulumi destroy
Previewing destroy (dev)

     Type                         Name              Plan       
 -   pulumi:pulumi:Stack          iac-ws-infra-dev  delete     
 -   └─ azure:core:ResourceGroup  resourceGroup     delete     
 
Resources:
    - 2 to delete

Do you want to perform this destroy? yes
Destroying (dev)

     Type                         Name              Status      
 -   pulumi:pulumi:Stack          iac-ws-infra-dev  deleted     
 -   └─ azure:core:ResourceGroup  resourceGroup     deleted     
 
Resources:
    - 2 deleted
```

## Useful links

* [Pulumi CLI](https://www.pulumi.com/docs/reference/cli/)
* [pulumi preview](https://www.pulumi.com/docs/reference/cli/pulumi_preview/)
* [pulumi up](https://www.pulumi.com/docs/reference/cli/pulumi_up/)
* [pulumi destroy](https://www.pulumi.com/docs/reference/cli/pulumi_destroy/)
* [pulumi stack](https://www.pulumi.com/docs/reference/cli/pulumi_stack/)

## Next: working with stack

[Go to lab-03](../lab-03/readme.md)