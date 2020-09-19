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

## Task #3 - modify your resources

Now, let's make some modifications to our resources, for example, add Tags.



## Task #4 - deploy resource changes

## Task #5 - destroy resources

## Checkpoint

## Useful links

* [Pulumi CLI](https://www.pulumi.com/docs/reference/cli/)
* [pulumi preview](https://www.pulumi.com/docs/reference/cli/pulumi_preview/)
* [pulumi up](https://www.pulumi.com/docs/reference/cli/pulumi_up/)
* [pulumi destroy](https://www.pulumi.com/docs/reference/cli/pulumi_destroy/)
* [pulumi stack](https://www.pulumi.com/docs/reference/cli/pulumi_stack/)

## Next: working with stack

[Go to lab-03](../lab-03/readme.md)