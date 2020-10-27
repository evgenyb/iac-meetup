# lab-02 - add AppInsight into the `base` stack

## Estimated completion time - xx min

Application Insights will be used by Azure FUnctions to collect application logs and metrics. Azure function instances and corresponding resource groups will be immutable, meaning they will periodically be de-commissioned and re-provisioned, therefore we don't want to place Application Insight into the `blue|green` resource groups, but instead, place it into the `base` resource group.

Azure functions will need AppInsights instrumentation key and connection string to configure access to AppInsight, therefore we need to expose this information as a `base` Stack outputs and use inter-stack dependencies to access this information from the `workload` Stack.

## Goals

* Add Application Insights resource into the `base` project
* Expose `InstrumentationKey` and `AppInsightConnectionString` as stack Outputs
* Provision new instance of Application Insights

## Useful links

* [What is Application Insights?](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview?WT.mc_id=AZ-MVP-5003837)
* [Pulumi: Insights reference](https://www.pulumi.com/docs/reference/pkg/azure/appinsights/insights/)
* [Pulumi: Inter-Stack Dependencies](https://www.pulumi.com/docs/intro/concepts/organizing-stacks-projects/#inter-stack-dependencies)
* [Pulumi: Inputs and Outputs](https://www.pulumi.com/docs/intro/concepts/programming-model/#outputs)
* [Pulumi: Stack Outputs](https://www.pulumi.com/docs/intro/concepts/programming-model/#stack-outputs)
* [How many Application Insights resources should I deploy](https://docs.microsoft.com/en-us/azure/azure-monitor/app/separate-resources?WT.mc_id=AZ-MVP-5003837)

## Task #1 - add ApplicationInsight resource

First, add `Pulumi.Azure.AppInsights` namespace to the using statements.

```c#
using Pulumi.Azure.AppInsights;
```

Here is the [reference documentation](https://www.pulumi.com/docs/reference/pkg/azure/appinsights/insights/) for the `Insights` resource.

We will use `Web` as an `ApplicationType` since this is ASP.NET.

```c#
var appInsights = new Insights("ai", new InsightsArgs
{
    Name = $"iac-ws4-{environment}-ai",
    ApplicationType = "web",
    ResourceGroupName = resourceGroup.Name
});
```

## Task #2 - add InstrumentationKey and AppInsightConnectionString Outputs

Add 2 class properties

```c#
[Output] public Output<string> InstrumentationKey { get; set; }
[Output] public Output<string> AppInsightConnectionString { get; set; }
```

Set the appropriate values after AppInsight is created.

```c#
InstrumentationKey = appInsights.InstrumentationKey;
AppInsightConnectionString = Output.Format($"InstrumentationKey={appInsights.InstrumentationKey}");
```

## Task #3 - deploy stack

```bash
pulumi up
Previewing update (lab)

     Type                           Name          Plan
     pulumi:pulumi:Stack            ws4-base-lab
 +   └─ azure:appinsights:Insights  ai            create
 
Outputs:
  + AppInsightConnectionString: output<string>
  + InstrumentationKey        : output<string>

Resources:
    + 1 to create
    2 unchanged

Do you want to perform this update? yes
Updating (lab)

     Type                           Name          Status
     pulumi:pulumi:Stack            ws4-base-lab
 +   └─ azure:appinsights:Insights  ai            created
 
Outputs:
  + AppInsightConnectionString: "InstrumentationKey=..."
  + InstrumentationKey        : "..."

Resources:
    + 1 created
    2 unchanged

Duration: 24s
```

## Next: implement simple Azure Function

[Go to lab-03](../lab-03/readme.md)