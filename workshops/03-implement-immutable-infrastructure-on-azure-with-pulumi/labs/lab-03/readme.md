# lab-03 - working with stack

## Estimated completion time - ?? min

Every Pulumi program is deployed to a stack. A stack is an isolated, independently configurable instance of a Pulumi program. The typical use-case scenario for stack is environments (such as dev, qa, staging and prod).

## Goals

## Useful links

* [Pulumi: programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/)
* [Pulumi: stacks](https://www.pulumi.com/docs/intro/concepts/stack/)
* [pulumi stack command](https://www.pulumi.com/docs/reference/cli/pulumi_stack/)
* [Pulumi: Stack Outputs](https://www.pulumi.com/docs/intro/concepts/programming-model/#stack-outputs)

## Task #1 - cerate new project

To create new project

```bash
$ mkdir lab-03
$ cd lab-03
$ pulumi new azure-csharp
```

Let's remove code defining Storage Account resource and output property, so the only resource we should have is resource group and deploy it.

```bash
$ pulumi up

```

## Task #2 - working with `pulumi stack` commands

### Show list of stacks

To see the list of stacks associated with the current project, use `pulumi stack ls`.

```bash
$ pulumi stack ls
NAME  LAST UPDATE  RESOURCE COUNT  URL
dev*  n/a          n/a             https://app.pulumi.com/evgenyb/lab-03/dev
```

### Create new stack

Let's create new `prod` stack that will represent our production environment.

```bash
$ pulumi stack init prod
$ pulumi stack ls
NAME   LAST UPDATE  RESOURCE COUNT  URL
dev    n/a          n/a             https://app.pulumi.com/evgenyb/lab-03/dev
prod*  n/a          n/a             https://app.pulumi.com/evgenyb/lab-03/prod
```

Note, when you add new stack, it becomes an active stack (marked with `*` at the list).

### Select stack

The pulumi operations like `config`, `preview`, `update` and `destroy` operate on the active stack (marked with `*` at the output of `pulumi stack ls` command). To change the active stack, run `pulumi stack select` command.

Let's get back to `dev` stack.

```bash
$ pulumi stack select dev
$ pulumi stack ls
NAME  LAST UPDATE     RESOURCE COUNT  URL
dev*  40 seconds ago  3               https://app.pulumi.com/evgenyb/lab-03/dev
prod  n/a             n/a             https://app.pulumi.com/evgenyb/lab-03/prod
```

### View stack resources

To view details of the currently selected stack, run pulumi stack with no arguments. This displays the metadata, resources and output properties associated with the stack.

```bash
$ pulumi stack
Current stack is dev:
    Owner: evgenyb
    Last updated: 9 seconds ago (2020-09-27 10:27:22.3657731 +0200 CEST)
    Pulumi version: v2.10.2
Current stack resources (3):
    TYPE                                           NAME
    pulumi:pulumi:Stack                            lab-03-dev
    ├─ azure:core/resourceGroup:ResourceGroup      resourceGroup
    └─ pulumi:providers:azure                      default_3_23_0

Current stack outputs (0):
    No output values currently in this stack
```

### Import / Export stack

A stack can be exported to see the json data associated with the stack. The stack can then be imported to set the current state of the stack to the new values.

```bash
$ pulumi stack export
{
    "version": 3,
    "deployment": {
        "manifest": {
            "time": "2020-09-27T10:27:22.3657731+02:00",
            "magic": "025dfc1d117429348e6e7b803d2a4553ccb696ddad474136fcac4f7fa8123e00",
            "version": "v2.10.2"
        },
        "secrets_providers": {
            "type": "service",
            "state": {
                "url": "https://api.pulumi.com",
                "owner": "evgenyb",
                "project": "lab-03",
                "stack": "dev"
            }
        },
        "resources": [
            {
                "urn": "urn:pulumi:dev::lab-03::pulumi:pulumi:Stack::lab-03-dev",
                "custom": false,
                "type": "pulumi:pulumi:Stack"
            },
...
```

## Task #3 - use stack name as part of the resource name

There are 2 stacks in our projects now: `dev` and `prod` and we want to use the following naming convention for resource group name:

`iac-ws3-<stack>-rg`.

By default, Pulumi will use the name of the resource, specified in the constructor and concatenate it with unique string. For instance, if I create resource group without any parameters `var resourceGroup = new ResourceGroup("resourceGroup");`, Pulumi will create resource group called `resourcegroup97b6850f`. This is OK behavior for some of the scenarios, but doesn't work for us. If you want to control the name of the resource, use `ResourceGroupArgs` object (or `<ResourceType>Args` class for other type of Azure resources) and use `Name` property to tell Pulumi how to name the resource.

```c#
var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs
{
    Name = "iac-ws3-dev-rg"
});
```

To fulfill our requirements we need to dynamically generate resource group name based on the current Stack. To programmatically get the current stack name, use `Deployment.Instance.StackName` syntax. Here is my implementation

```c#
var stackName = Deployment.Instance.StackName;
var resourceGroup = new ResourceGroup("resourceGroup", new ResourceGroupArgs
{
    Name = $"iac-ws3-{stackName}-rg"
});
```

Let's check Pulumi update plan, run `pulumi up` and select details

```bash
$ pulumi up
Previewing update (dev)

     Type                         Name           Plan        Info
     pulumi:pulumi:Stack          lab-03-dev                 
 +-  └─ azure:core:ResourceGroup  resourceGroup  replace     [diff: ~name]
 
Resources:
    +-1 to replace
    1 unchanged

Do you want to perform this update? details
  pulumi:pulumi:Stack: (same)
    [urn=urn:pulumi:dev::lab-03::pulumi:pulumi:Stack::lab-03-dev]
    --azure:core/resourceGroup:ResourceGroup: (delete-replaced)
        [id=/subscriptions/8878beb2-5e5d-4418-81ae-783674eea324/resourceGroups/resourcegroup97b6850f]
        [urn=urn:pulumi:dev::lab-03::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::lab-03::pulumi:providers:azure::default_3_23_0::9d234f98-aab6-404d-9a01-2fd6b0dc2b4a]
    +-azure:core/resourceGroup:ResourceGroup: (replace)
        [id=/subscriptions/8878beb2-5e5d-4418-81ae-783674eea324/resourceGroups/resourcegroup97b6850f]
        [urn=urn:pulumi:dev::lab-03::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::lab-03::pulumi:providers:azure::default_3_23_0::9d234f98-aab6-404d-9a01-2fd6b0dc2b4a]
      ~ name: "resourcegroup97b6850f" => "iac-ws3-dev-rg"
    ++azure:core/resourceGroup:ResourceGroup: (create-replacement)
        [id=/subscriptions/8878beb2-5e5d-4418-81ae-783674eea324/resourceGroups/resourcegroup97b6850f]
        [urn=urn:pulumi:dev::lab-03::azure:core/resourceGroup:ResourceGroup::resourceGroup]
        [provider=urn:pulumi:dev::lab-03::pulumi:providers:azure::default_3_23_0::9d234f98-aab6-404d-9a01-2fd6b0dc2b4a]
      ~ name: "resourcegroup97b6850f" => "iac-ws3-dev-rg"
```

We already deployed `dev` stack and Pulumi created resource group `resourcegroup97b6850f` on Azure. You can't rename resource groups, therefore Pulumi will try to delete existing resource group, rename it in the stack and provision new resource group. THis is Ok operation to do during labs, but this is definitely something you should avoid in real life. Instead, think what is your naming strategy and convention before you start creating resources.

To deploy changes, select `--yes`

```bash
Do you want to perform this update? yes
Updating (dev)

     Type                         Name           Status       Info
     pulumi:pulumi:Stack          lab-03-dev                  
 +-  └─ azure:core:ResourceGroup  resourceGroup  replaced     [diff: ~name]
 
Resources:
    +-1 replaced
    1 unchanged

Duration: 54s
```

## Task #4 - deploy `prod` stack

To deploy `prod` stack we should first select it and the deploy it

```bash
$ pulumi stack select prod
$ pulumi up
Previewing update (prod)

     Type                         Name           Plan       Info
 +   pulumi:pulumi:Stack          lab-03-prod    create     
     └─ azure:core:ResourceGroup  resourceGroup             1 error
 
Diagnostics:
  azure:core:ResourceGroup (resourceGroup):
    error: azure:core/resourceGroup:ResourceGroup resource 'resourceGroup' has a problem: Missing required property 'location'. Either set it explicitly or configure it with 'pulumi config set azure:location <value>'.
```

Most likely it will fail with `Missing required property 'location'` error message. When you cerate new project you are asked to specify Azure resources location. When you create new stack, Pulumi doesn't ask you, therefore you either need to explicitly set Location property of `ResourceGroupArgs` class, or configure it by running the following command

```bash
pulumi config set azure:location northeurope
```

We will cover how to work with configuration in [lab-07](labs/lab-07/readme.md).

When you fix it, run `pulumi up` again

```bash
$ pulumi up
Previewing update (prod)

     Type                         Name           Plan       
 +   pulumi:pulumi:Stack          lab-03-prod    create     
 +   └─ azure:core:ResourceGroup  resourceGroup  create     
 
Resources:
    + 2 to create

Do you want to perform this update? yes
Updating (prod)

     Type                         Name           Status      
 +   pulumi:pulumi:Stack          lab-03-prod    created     
 +   └─ azure:core:ResourceGroup  resourceGroup  created     
 
Resources:
    + 2 created

Duration: 12s
```

## Task #5 - cleanup

Destroy resources and remove `prod` stack

```bash
$ pulumi destroy -s prod --yes
$ pulumi stack rm prod
```

Destroy resources and remove `dev` stack

```bash
$ pulumi destroy -s dev --yes
$ pulumi stack rm dev
```

## Next: working with stack Outputs

[Go to lab-04](../lab-04/readme.md)
