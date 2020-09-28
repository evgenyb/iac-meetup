# lab-01 - Pulumi basics

## Estimated completion time - 10-15 min

Infrastructure in Pulumi is organized as projects. Each project is a single program that, when run, declares the desired infrastructure for Pulumi to manage.

## Goals

* Create new project and get familiar with program structure
* Learn basic Pulumi CLI commands and how to use them to control lifecycle of the resources

## Useful links

* [Pulumi: projects](https://www.pulumi.com/docs/intro/concepts/project/)
* [Pulumi: create new Azure project](https://www.pulumi.com/docs/get-started/azure/create-project/)
* [Pulumi: programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/)
* [Pulumi CLI](https://www.pulumi.com/docs/reference/cli/)
* [pulumi preview](https://www.pulumi.com/docs/reference/cli/pulumi_preview/)
* [pulumi up](https://www.pulumi.com/docs/reference/cli/pulumi_up/)
* [pulumi destroy](https://www.pulumi.com/docs/reference/cli/pulumi_destroy/)
* [pulumi stack](https://www.pulumi.com/docs/reference/cli/pulumi_stack/)

## Task #1 - create new project

```bash
$ mkdir lab-01
$ cd lab-01
$ pulumi new azure-csharp
```

During the workshop I will use C# as a language and Azure as a cloud provider, therefore I used `azure-csharp` template. If you use different language, feel free to select it instead of C#. You get full list of available templates by running the following command and scroll to the `Available Templates:` section.

```bash
pulumi new --help
```

If all prerequisites were installed, you should see the following message

```txt
Your new project is ready to go!

To perform an initial deployment, run 'pulumi up'
```

and that indicates that your project was successfully created.

## Task #2 - review your project

Now, open your project in the IDE of your choice. For dotnet projects, you can use [VS Code](https://code.visualstudio.com/), [Visual Studio](https://visualstudio.microsoft.com/) or [JetBrains Rider](https://www.jetbrains.com/rider/). I will use VS Code.

Open your project in VS code

```bash
$ code .
```

You will find the following files inside project folder:

Let’s review some of the generated project files:

* Pulumi.yaml - defines the project
* Pulumi.dev.yaml - contains configuration values for `dev` stack
* Program.cs  - program entry point
* MyStack.cs - the Pulumi program that defines stack resources. The default stack contains Azure Resource group, Azure Storage Account resources and exposes Storage Account connection string as Stack output. We will work with stack output at [lab-04](../lab-04/readme.md).

Let's remove code defining Storage Account resource and output property, so the only resource we should have is a resource group.

```c#
public MyStack()
{
    // Create an Azure Resource Group
    var resourceGroup = new ResourceGroup("resourceGroup");
}
```

## Task #3 - preview of updates to a stack’s resources

To show a preview of updates run the following command

```bash
$ pulumi preview
Previewing update (dev)

     Type                         Name            Plan       
 +   pulumi:pulumi:Stack          lab-01-dev      create     
 +   └─ azure:core:ResourceGroup  resourceGroup   create     
 
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
'dotnet build -nologo .' completed successfully
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:dev::lab-01::pulumi:pulumi:Stack::lab-01-dev]
    + azure:core/resourceGroup:ResourceGroup: (create)
        [urn=urn:pulumi:dev::lab-01::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::lab-01::pulumi:providers:azure::default_3_23_0::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
        location  : "westeurope"
        name      : "resourcegroup82f58714"
Resources:             
    + 2 to create
```

## Task #4 - set ResourceGroup name to `iac-lab01-rg`

By default, Pulumi takes resource name and adds unique string to the end of the original name. As you can see from the `preview --diff` output above, the original resource group name we used was `resourceGroup`, but the actual resource group name becomes `resourcegroup82f58714`. This is totally OK behavior in some of use-cases, but normally you use your own naming convention, therefore you should be able to specify resource name. You do this by sending additional parameter to the resource constructor. In case of `ResourceGroup` object, use `ResourceGroupArgs` class and specify resource group name via `Name` property.

```c#
public MyStack()
{
    // Create an Azure Resource Group
    var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs {
        Name = "iac-lab01-rg"
    });
}
```

## Task #5 - deploy the stack

Now, let's deploy the stack:

```bash
$ pulumi up
```

The first thing this command does it shows a preview of the changes (aka plan) that will be made (similar to `pulumi preview`):

```bash
$ pulumi up

     Type                         Name            Plan       
 +   pulumi:pulumi:Stack          lab-01-dev  create     
 +   └─ azure:core:ResourceGroup  resourceGroup   create     
 
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

     Type                         Name           Plan
 +   pulumi:pulumi:Stack          lab-01-dev     create
 +   └─ azure:core:ResourceGroup  resourceGroup  create

Resources:
    + 2 to create

Do you want to perform this update? details
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:dev::lab-01::pulumi:pulumi:Stack::lab-01-dev]
    + azure:core/resourceGroup:ResourceGroup: (create)
        [urn=urn:pulumi:dev::lab-01::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::lab-01::pulumi:providers:azure::default_3_23_0::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
        location  : "westeurope"
        name      : "iac-lab01-rg"

```

Choosing `yes` will create resources in Azure.

```bash
Do you want to perform this update? yes
Updating (dev)

View Live: https://app.pulumi.com/evgenyb/lab-01/dev/updates/2

     Type                         Name           Status
 +   pulumi:pulumi:Stack          lab-01-dev     created
 +   └─ azure:core:ResourceGroup  resourceGroup  created

Resources:
    + 2 created

Duration: 12s
```

We can check the resource was created by using `az cli`

```bash
$ az group show -n iac-lab01-rg
{
  "id": "/subscriptions/.../resourceGroups/iac-lab01-rg",
  "location": "westeurope",
  "managedBy": null,
  "name": "iac-lab01-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "type": "Microsoft.Resources/resourceGroups"
}
```

## Task #6 - modify your resources and deploy changes

Now, let's make some modifications to our resources, for example, add Tags.

```c#
public MyStack()
{
    // Create an Azure Resource Group
    var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs{
        Name = "iac-lab01-rg",
        Tags = {
            { "owner", "team-platform" },
            { "environment", "dev" }
        }
    });
}
```

Deploy changes

```bash
$ pulumi up
Previewing update (dev)

     Type                         Name           Plan       Info
     pulumi:pulumi:Stack          lab-01-dev                
 ~   └─ azure:core:ResourceGroup  resourceGroup  update     [diff: ~tags]
 
Resources:
    ~ 1 to update
    1 unchanged

Do you want to perform this update? details
  pulumi:pulumi:Stack: (same)
    [urn=urn:pulumi:dev::lab-01::pulumi:pulumi:Stack::lab-01-dev]
    ~ azure:core/resourceGroup:ResourceGroup: (update)
        [id=/subscriptions/.../resourceGroups/iac-lab01-rg]
        [urn=urn:pulumi:dev::lab-01::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::lab-01::pulumi:providers:azure::default_3_23_0::d731a9ab-79dc-415f-9a17-3fbd1231742b]
      ~ tags: {
          + environment: "dev"
          + owner      : "team-platform"
        }

Do you want to perform this update?  [Use arrows to move, enter to select, type to filter]
  yes
> no
  details
```

Pulumi will update the resource group and add two tags. Choosing `yes` will proceed with the update.

Check that tags was added by running 

```bash
$ az group show -n iac-lab01-rg
{
  "id": "/subscriptions/.../resourceGroups/iac-lab01-rg",
  "location": "westeurope",
  "managedBy": null,
  "name": "iac-lab01-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": {
    "environment": "dev",
    "owner": "team-platform"
  },
  "type": "Microsoft.Resources/resourceGroups"
}
```

## Task #7 - destroy resources

Quite often you need to remove all components included into your infrastructure. To clean up and tear down the resources that are part of our stack, run the following command:

```bash
$ pulumi destroy
Previewing destroy (dev)

     Type                         Name            Plan       
 -   pulumi:pulumi:Stack          lab-01-dev  delete     
 -   └─ azure:core:ResourceGroup  resourceGroup   delete     
 
Resources:
    - 2 to delete

Do you want to perform this destroy? yes
Destroying (dev)

     Type                         Name            Status      
 -   pulumi:pulumi:Stack          lab-01-dev  deleted     
 -   └─ azure:core:ResourceGroup  resourceGroup   deleted     
 
Resources:
    - 2 deleted

Duration: 55s
```

## Next: working with Stacks

[Go to lab-02](../lab-02/readme.md)
