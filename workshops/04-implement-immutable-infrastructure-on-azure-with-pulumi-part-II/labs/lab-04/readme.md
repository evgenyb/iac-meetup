# lab-04 - add Azure Function infrastructure into the workload stack

## Estimated completion time - xx min

There are multiple ways one can deploy Azure Function. In our lab we will use the option that allows to [run your Azure Functions from a package file](https://docs.microsoft.com/en-us/azure/azure-functions/run-functions-from-deployment-package?WT.mc_id=AZ-MVP-5003837). To enable function app to run from a package, we need to add a `WEBSITE_RUN_FROM_PACKAGE` setting to our function app settings. The `WEBSITE_RUN_FROM_PACKAGE` setting should contain a location of a specific package file we want to run. We will use Blob storage to store the package, therefore we should use a private container with a Shared Access Signature (SAS) to enable the Functions runtime to access to the package.

Basically the plan is to build/publish Azure function to the `..\..\published` folder. Then configure `Blob` object to upload the content of this folder into the Blob called `zip` and configure Azure function `WEBSITE_RUN_FROM_PACKAGE` app settings with SAS link to that blob.

## Goals

Here is the list of infrastructure components we need to add for our Azure Function deployment:

* Azure App Service plan
* Azure Storage Account
* Private container
* Azure blob, with compiled Azure Function binaries

We also need to configure `AppSettings` for our Azure function with the following settings:

* `WEBSITE_RUN_FROM_PACKAGE` - a location of a Azure function  package file we want to run
* `ENVIRONMENT_NAME` - the deployment Stack name
* `APPINSIGHTS_INSTRUMENTATIONKEY` - Application Insights Instrumentation Key
* `APPLICATIONINSIGHTS_CONNECTION_STRING` - Application Insight Connection string

## Useful links

* [Run your Azure Functions from a package file](https://docs.microsoft.com/en-us/azure/azure-functions/run-functions-from-deployment-package?WT.mc_id=AZ-MVP-5003837)
* [Azure App Service plan overview](https://docs.microsoft.com/en-us/azure/app-service/overview-hosting-plans?WT.mc_id=AZ-MVP-5003837)
* [Storage account overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview?WT.mc_id=AZ-MVP-5003837)
* [Grant limited access to Azure Storage resources using shared access signatures (SAS)](https://docs.microsoft.com/en-us/azure/storage/common/storage-sas-overview?WT.mc_id=AZ-MVP-5003837)
* [Pulumi: Storage](https://www.pulumi.com/docs/reference/pkg/azure/storage/)
* [Pulumi: Container](https://www.pulumi.com/docs/reference/pkg/azure/storage/container)
* [Pulumi: Blob](https://www.pulumi.com/docs/reference/pkg/azure/storage/Blob)
* [Pulumi: Plan](https://www.pulumi.com/docs/reference/pkg/azure/appservice/plan/)
* [Pulumi: FunctionApp](https://www.pulumi.com/docs/reference/pkg/azure/appservice/functionapp/)
* [Pulumi: Inter-Stack Dependencies](https://www.pulumi.com/docs/intro/concepts/organizing-stacks-projects/#inter-stack-dependencies)

## Task #1 - add Storage account, Container and Blob resource

First, Make sure that you are at `infra/workload` folder.
Next, add `Pulumi.Azure.Storage` namespace to the using statements.

```c#
using Pulumi.Azure.Storage;
```

Use reference documentation for

* [Storage](https://www.pulumi.com/docs/reference/pkg/azure/storage/)
* [Container](https://www.pulumi.com/docs/reference/pkg/azure/storage/container)
* [Blob](https://www.pulumi.com/docs/reference/pkg/azure/storage/Blob)

and implement Storage, Private Container and Blob components.

Here is my version

```c#
// Create an Azure Storage Account
var storageAccount = new Account("iacws4sa", new AccountArgs
{
    ResourceGroupName = resourceGroup.Name,
    AccountReplicationType = "LRS",
    AccountTier = "Standard"
});

// Create private Container
var container = new Container("zips", new ContainerArgs
{
    Name = "artifacts",
    StorageAccountName = storageAccount.Name,
    ContainerAccessType = "private"
});

// Create blob and upload binaries from ../../published folder
var blob = new Blob("zip", new BlobArgs
{
    StorageAccountName = storageAccount.Name,
    StorageContainerName = container.Name,
    Type = "Block",
    Source = new FileArchive("../../published")
});

// Generate SAS url to the Blob
var codeBlobUrl = SharedAccessSignature.SignedBlobReadUrl(blob, storageAccount);
```

## Task #2 - add Service Plan and Azure function

First, add `Pulumi.Azure.AppService` and `Pulumi.Azure.AppService.Inputs` namespaces to the using statements.

```c#
using Pulumi.Azure.AppService;
using Pulumi.Azure.AppService.Inputs;
```

Here is a couple of notes:

1. We want to integrate Azure Function with Application Insights. Since Application Insights is deployed to `base` stack, we need to use inter-stack dependencies to read Instrumentation Key from the `base` Stack. Use `StackReference` object to get access to the `base` Stack.

```c#
var baseStack = new StackReference("evgenyb/ws4-base/lab");
```

The StackReference constructor takes as input a string of the form `<organization>/<project>/<stack>`, so change it according to your environment.

Use the following reference documentation for

* [Plan](https://www.pulumi.com/docs/reference/pkg/azure/appservice/plan/)
* [FunctionApp](https://www.pulumi.com/docs/reference/pkg/azure/appservice/functionapp/)

and implement Service plan and Azure function components.

Here is my version

```c#
// Create App Service Plan
var servicePlan = new Plan("iacws4sp", new PlanArgs
{
    ResourceGroupName = resourceGroup.Name,
    Kind = "FunctionApp",
    Sku = new PlanSkuArgs
    {
        Tier = "Dynamic",
        Size = "Y1",
    }
});

// Read Application Insights Instrumentation Key and connection string from the base Stack
var baseStack = new StackReference("evgenyb/ws4-base/lab");
var aiInstrumentationKey = baseStack.RequireOutput("InstrumentationKey").Apply(x => x.ToString()!);
var aiConnectionString = baseStack.RequireOutput("AppInsightConnectionString").Apply(x => x.ToString()!);

// Create Azure Function
var app = new FunctionApp("iacws4func", new FunctionAppArgs
{
    ResourceGroupName = resourceGroup.Name,
    AppServicePlanId = servicePlan.Id,
    AppSettings =
    {
        {"runtime", "dotnet"},
        {"WEBSITE_RUN_FROM_PACKAGE", codeBlobUrl},
        {"ENVIRONMENT_NAME", environment},
        {"APPINSIGHTS_INSTRUMENTATIONKEY", aiInstrumentationKey},
        {"APPLICATIONINSIGHTS_CONNECTION_STRING", aiConnectionString}
    },

    StorageAccountName = storageAccount.Name,
    StorageAccountAccessKey = storageAccount.PrimaryAccessKey,
    Version = "~3"
});
```

## Task #3 - add `Hostname` stack Output

We will use Azure Front Door to orchestrate traffic and Azure Function will be configured as a FrontDoor endpoint. Since Front Door is part of the `base` Stack and in order to get access to the Azure Function hos name, we should expose this as a Stack output and use inter-stack dependencies.

Let's add `Hostname` output parameter.

```c#
[Output] public Output<string> Hostname { get; set; }
```

and initialize it after Azure Function is created.

```c#
Hostname = app.DefaultHostname;
```

## Task #4 - deploy stack

```bash
pulumi up        
Previewing update (lab-blue)


     Type                             Name                   Plan
 +   pulumi:pulumi:Stack              ws4-workload-lab-blue  create
 +   ├─ azure:core:ResourceGroup      rg                     create
 +   ├─ azure:storage:Account         iacws4sa               create
 +   ├─ azure:appservice:Plan         iacws4sp               create
 +   ├─ azure:storage:Container       zips                   create
 +   ├─ azure:storage:Blob            zip                    create
 +   └─ azure:appservice:FunctionApp  iacws4func             create
 
Resources:
    + 7 to create

Do you want to perform this update? yes
Updating (lab-blue)


     Type                             Name                   Status
 +   pulumi:pulumi:Stack              ws4-workload-lab-blue  created
 +   ├─ azure:core:ResourceGroup      rg                     created
 +   ├─ azure:storage:Account         iacws4sa               created
 +   ├─ azure:appservice:Plan         iacws4sp               created
 +   ├─ azure:storage:Container       zips                   created
 +   ├─ azure:storage:Blob            zip                    created
 +   └─ azure:appservice:FunctionApp  iacws4func             created
 
Outputs:
    Hostname: "iacws4func<yourID>.azurewebsites.net"

Resources:
    + 7 created

Duration: 1m39s
```

## Task #5 - test Azure function

Now we can test our Azure function (note)

```bash
curl --get https://iacws4func<yourID>.azurewebsites.net/api/health
[lab-blue]: OK
```

To check that integration with Application Insight works we can start hammering our Azure function with `watch` command and monitor Application Insights `Live Metrics`.

```bash
watch -n 0.1 curl -s --get https://iacws4func<yourID>.azurewebsites.net/api/health
```

if you using Powershell, you can use this command

```Powershell
while (1) {curl -s --get https://iacws4func<yourID>.azurewebsites.net/api/health; cls}
```

This commands will send request to Azure function every 100 ms (10 requests per sec).

![logo](images/ai-integration-demo.gif)

## Next: implement Azure Front Door infrastructure into the `base` stack

[Go to lab-05](../lab-05/readme.md)
