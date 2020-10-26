# lab-01 - setting up the project and stacks structure

## Estimated completion time - xx min

I will use C# as a language and Rider as my IDE. If you use different language or different IDE, you may need to adjust this lab for your environment.

## Stacks structure

Based on our architecture model, there will be only one instance of Front Door and Application insight per environment, therefore we place them together into `base` Project. `base` will have one Stack per environment (for instance `lab`, `test`, `prod`).

Azure Function and supported resources (such as Service Plan and Storage account for published deployment artifacts), all have the same lifecycle and therefore should be placed under the same `workload` Project. `workload` will have 2 Stacks per environment one for `blue` and one for `green` deployment slots.

## Folders structure

```txt
    function
    infra
        base
        workload
    published
    scripts
```

* `function` - contains Azure function source code
* `infra` - contains Pulumi `base` and `workload` Projects
* `published` - contains Azure function deployment artifacts (binaries)
* `scripts` - contains deployment scripts

## Goals

* Setup the project structure
* Create `base` Pulumi project with `lab` stack
* Create `workload` Pulumi project with `lab-blue` and `lab-green` Stacks
* Add `base` and `workload` projects into solution file

## Useful links

* [Pulumi: projects](https://www.pulumi.com/docs/intro/concepts/project/)
* [Pulumi: create new Azure project](https://www.pulumi.com/docs/get-started/azure/create-project/)
* [Pulumi: programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/)
* [Pulumi: Organizing Projects and Stacks](https://www.pulumi.com/docs/intro/concepts/organizing-stacks-projects/)

## Task #1 - create folders structure

```bash
$ mkdir ws-04
$ cd ws-04
$ mkdir published
$ mkdir scripts
$ mkdir infra
$ cd infra
$ mkdir base
$ mkdir workload
```

## Task #2 - initialize `base` Pulumi project with `lab` Stack

Create new Pulumi project from `azure-csharp` template. Use `ws4-base` as Project name, `lab` as a Stack name and `westeurope` as an Azure resource location (but of course feel free to use the one that is close to you location).

```bash
$ cd base
$ pulumi new azure-csharp -n ws4-base -s lab -d ws4
Created project 'ws4-base'

Created stack 'lab'

azure:location: The Azure location to use: (WestUS) westeurope
Saved config

Installing dependencies...
...
Your new project is ready to go!
```

## Task #3 - cleanup default code

Rename `MyStack.cs` to `BaseStack.cs`.
Rename `MyStack` class to `BaseStack`.

> Tip. Use refactoring shortcuts `F2` for VS Code  or `Ctrl+Shift+R` in Rider or VS with Resharper.

Remove all code except resource group initialization and set resource group name to `iac-ws4-stackName-rg`.

Here is my version of `BaseStack` class

```c#
class BaseStack : Stack
{
    public BaseStack()
    {
        var environment = Deployment.Instance.StackName;

        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("rg", new ResourceGroupArgs{
            Name = $"iac-ws4-{environment}-rg"
        });
    }
}
```

## Task #4 - deploy `base` to `lab`

```bash
$ pulumi up --skip-preview
Updating (lab)

     Type                         Name          Status
 +   pulumi:pulumi:Stack          ws4-base-lab  created
 +   └─ azure:core:ResourceGroup  rg            created
 
Resources:
    + 2 created

Duration: 13s
```

Check that resource group was created

```bash
az group show -n iac-ws4-lab-rg  --query id  
"/subscriptions/.../resourceGroups/iac-ws4-lab-rg"
```

## Task #5 - initialize `workload` Pulumi project with `lab-blue` Stack

Create new Pulumi project from `azure-csharp` template. Use `ws4-workload` as Project name,  `lab-blue` as a Stack name and `westeurope` as an Azure resource location (and again, feel free to use the one that is close to you location).

```bash
$ cd ../workload
$ pulumi new azure-csharp -n ws4-workload -s lab-blue -d ws4-workload
Created project 'ws4-workload'

Created stack 'lab-blue'

azure:location: The Azure location to use: (WestUS) westeurope
Saved config

Installing dependencies...
...
Your new project is ready to go!
```

## Task #6 - cleanup default code

Rename `MyStack.cs` to `WorkloadStack.cs`.
Rename `MyStack` class to `WorkloadStack`.

> Tip. Use refactoring shortcuts `F2` for VS Code  or `Ctrl+R+R` in Rider or VS with Resharper.

Remove all code except resource group initialization and set resource group name to `iac-ws4-stackName-rg`.

Here is my version of `BaseStack` class

```c#
class WorkloadStack : Stack
{
    public WorkloadStack()
    {
        var environment = Deployment.Instance.StackName;

        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("rg", new ResourceGroupArgs{
            Name = $"iac-ws4-{environment}-rg"
        });
    }
}
```

## Task #7 - deploy `workload` to `lab-blue`

Run `pulumi up`, check the plan and if you are happy, deploy it.

```bash
$ pulumi up
Please choose a stack, or create a new one: lab-blue
Previewing update (lab-blue)

     Type                         Name                   Plan
 +   pulumi:pulumi:Stack          ws4-workload-lab-blue  create
 +   └─ azure:core:ResourceGroup  rg                     create                                                                                          
 
Resources:
    + 2 to create

Do you want to perform this update? details
+ pulumi:pulumi:Stack: (create)
    [urn=urn:pulumi:lab-blue::ws4-workload::pulumi:pulumi:Stack::ws4-workload-lab-blue]
    + azure:core/resourceGroup:ResourceGroup: (create)
        [urn=urn:pulumi:lab-blue::ws4-workload::azure:core/resourceGroup:ResourceGroup::rg]
        [provider=urn:pulumi:lab-blue::ws4-workload::pulumi:providers:azure::default_3_26_0::04da6b54-80e4-46f7-96ec-b56ff0331ba9]
        location  : "westeurope"
        name      : "iac-ws4-lab-blue-rg"

Do you want to perform this update? yes
Updating (lab-blue)

     Type                         Name                   Status
 +   pulumi:pulumi:Stack          ws4-workload-lab-blue  created
 +   └─ azure:core:ResourceGroup  rg                     created
 
Resources:
    + 2 created

Duration: 12s
```

Check that resource group was created

```bash
az group show -n iac-ws4-lab-blue-rg  --query id
"/subscriptions/.../resourceGroups/iac-ws4-lab-blue-rg"
```

## Task #8 - add `lab-green` Stack

Now, let's initialize second deployment slot - `lab-green`.

```bash
pulumi init -s lab-green
```

Set `azure:location` configuration to `westeurope`.

```bash
pulumi config set azure:location westeurope
```

## Next: add AppInsight into the base stack

[Go to lab-02](../lab-02/readme.md)
