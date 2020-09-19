# lab-01 - create new Pulumi project

## Estimated completion time - ?? min

## Goals

* create new project and get familiar with program structure

Infrastructure in Pulumi is organized as projects. Each project is a single program that, when run, declares the desired infrastructure for Pulumi to manage.

## Task #1 - create new project

```bash
$ mkdir iac-ws-infra
$ cd iac-ws-infra
$ pulumi new azure-csharp
```

In this workshop I will use C# as a language and Azure as a cloud provider, therefore I used `azure-csharp` template. If you use different language, feel free to select it instead of C#. You get full list of available templates by running the following command and scroll to the `Available Templates:` section.

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

Now you can open your project at the IDE you normally use. Since this is dotnet project, you can use [VS Code](https://code.visualstudio.com/), [Visual Studio](https://visualstudio.microsoft.com/) or [JetBrains Rider](https://www.jetbrains.com/rider/). I will use VS Code.

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

Let's remove code defining Storage Account resource and output property, so the only resource we should have is resource group.

## Checkpoint

:ballot_box_with_check: by the end of this lab, your `MyStack.cs` should look like this.

```c#
using Pulumi;
using Pulumi.Azure.Core;
using Pulumi.Azure.Storage;

class MyStack : Stack
{
    public MyStack()
    {
        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("resourceGroup");
    }
}
```

## Useful links

* [Pulumi: projects](https://www.pulumi.com/docs/intro/concepts/project/)
* [Pulumi: create new Azure project](https://www.pulumi.com/docs/get-started/azure/create-project/)
* [Pulumi: programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/)

## Next

[Go to lab-02](../lab-02/readme.md)