# lab-05 - add Azure Front Door infrastructure into the `base` stack

## Estimated completion time - xx min

## Switch logic

There are deployment 2 slots at `workload` Stack: `active` and `next`.

`active` contain the name (or color `blue`|`green`) of the `workload` Stack, containing Azure function that is currently active and receive traffic.

`next` is the name (or color `blue`|`green`) of the `workload` Stack that next deployment will be deployed to.

During the switch the following activities should take place in the following order:

* read `ActiveSlot` and `NextSlot` Outputs from the `base` Stack
* destroy `workload` next Stack (we do it just to make sure that we have a clean deployment)
* deploy new version of Azure function to the `NextSlot` Stack
* update `active.slot` and `next.slot` configuration values of the `base` Stack:
  * set `active.slot` value to `NextSlot`
  * set `next.slot` value to `ActiveSlot`
* deploy `base` Stack

During `base` stack deployment, Azure Front Door backend endpoints will be updated the way that the endpoint receiving traffic will point to the Azure Function deployed to the `active.slot` Stack. In case of cussesfull switch, the Outputs values of `base` Stack will be updated and `ActiveSlot` will contain the name of the active slot and `NextSlot` will contain the name of the next slot.

## Goals

## Useful links

* [What is Azure Front Door?](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-overview?WT.mc_id=AZ-MVP-5003837)
* [Azure Front Door documentation](https://docs.microsoft.com/en-us/azure/frontdoor?WT.mc_id=AZ-MVP-5003837)
* [Quickstart: Create a Front Door for a highly available global web application](https://docs.microsoft.com/en-us/azure/frontdoor/quickstart-create-front-door?WT.mc_id=AZ-MVP-5003837)
* [Pulumi: FrontDoor](https://www.pulumi.com/docs/reference/pkg/azure/frontdoor/frontdoor/)
* [Pulumi: Inter-Stack Dependencies](https://www.pulumi.com/docs/intro/concepts/organizing-stacks-projects/#inter-stack-dependencies)

## Task #1 - add Front Door resource into the `base`

FrontDoor is quite a complex resource. You are welcome to implement it yourself, but if you want to quickly get workable version, feel free to use my version. Here is my implementation of `BaseStack` class (`base` project).

Note! Your Azure Front Door should have unique name, because it will be registered at the global DNS. I suggest we use the following convention: `iac-ws4-<yourname>-fd`, where you use your short name or some unique string. Set the correct value for `fdName` variable.

The `GetBackends` method contains switching logic.

The `GetEndpoint` method uses inter-stack dependencies to read Azure Function Hostname from the `workload` Stacks. The `StackReference` constructor takes as input a string of the form `<organization>/<project>/<stack>`, so change it according to your environment.

```c#
using System.Collections.Generic;
using Pulumi;
using Pulumi.Azure.AppInsights;
using Pulumi.Azure.Core;
using Pulumi.Azure.FrontDoor;
using Pulumi.Azure.FrontDoor.Inputs;

class BaseStack : Stack
{
    private readonly Config _config;

    public BaseStack()
    {
        _config = new Config();
        var environment = Deployment.Instance.StackName;

        // Create an Azure Resource Group
        var resourceGroup = new ResourceGroup("rg", new ResourceGroupArgs
        {
            Name = $"iac-ws4-{environment}-rg"
        });

        var appInsights = new Insights("ai", new InsightsArgs
        {
            Name = $"iac-ws4-{environment}-ai",
            ApplicationType = "web",
            ResourceGroupName = resourceGroup.Name
        });

        InstrumentationKey = appInsights.InstrumentationKey;
        AppInsightConnectionString = Output.Format($"InstrumentationKey={appInsights.InstrumentationKey}");

        var fdName = "iac-ws4-<YOUR-ID>-fd";
        var fd = new Frontdoor("fd", new FrontdoorArgs
        {
            Name = fdName,
            ResourceGroupName = resourceGroup.Name,
            EnforceBackendPoolsCertificateNameCheck = false,
            FriendlyName = fdName,
            FrontendEndpoints =
            {
                new FrontdoorFrontendEndpointArgs
                {
                    Name = "default-frontend",
                    HostName = $"{fdName}.azurefd.net"
                }
            },
            BackendPools = {
                new FrontdoorBackendPoolArgs
                {
                    Name = "function-backend-pool",
                    Backends = GetBackends(environment),
                    HealthProbeName = "function-health-probe",
                    LoadBalancingName = "default"
                }
            },
            RoutingRules =
            {
                new FrontdoorRoutingRuleArgs
                {
                    Name = "function-rule",
                    FrontendEndpoints = { "default-frontend" },
                    PatternsToMatches = "/*",
                    AcceptedProtocols = { "Https" },
                    ForwardingConfiguration = new FrontdoorRoutingRuleForwardingConfigurationArgs
                    {
                        BackendPoolName = "function-backend-pool",
                        ForwardingProtocol = "MatchRequest"
                    }
                }
            },
            BackendPoolHealthProbes =
            {
                new FrontdoorBackendPoolHealthProbeArgs
                {
                    Name = "function-health-probe",
                    Path = "/api/health",
                    Protocol = "Https",
                    IntervalInSeconds = 30,
                    ProbeMethod = "GET"
                }
            },
            BackendPoolLoadBalancings =
            {
                new FrontdoorBackendPoolLoadBalancingArgs
                {
                    Name = "default",
                    SampleSize = 4,
                    AdditionalLatencyMilliseconds = 0,
                    SuccessfulSamplesRequired = 2
                }
            }
        });
    }

    private List<FrontdoorBackendPoolBackendArgs> GetBackends(string environment)
    {
        // Read active and next slots from the Stack configuration 
        var nextSlot = _config.Require("next.slot");
        var activeSlot = _config.Require("active.slot");

        // hard switch
        ActiveSlot = Output.Create(activeSlot);
        NextSlot = Output.Create(nextSlot);
        return new List<FrontdoorBackendPoolBackendArgs>
        {
            GetEndpoint(environment, activeSlot, 100)
        };
    }

    private static FrontdoorBackendPoolBackendArgs GetEndpoint(string environment, string slot, int canaryPercentage)
    {
        var workloadStack = new StackReference($"evgenyb/ws4-workload/{environment}-{slot}");
        var url = workloadStack.RequireOutput("Hostname").Apply(x => x.ToString()!);

        return new FrontdoorBackendPoolBackendArgs
        {
            Address = url,
            HostHeader = url,
            HttpsPort = 443,
            HttpPort = 80,
            Weight = canaryPercentage,
            Enabled = true
        };
    }

    [Output] public Output<string> InstrumentationKey { get; set; }
    [Output] public Output<string> AppInsightConnectionString { get; set; }

    [Output] public Output<string> ActiveSlot { get; set; }
    [Output] public Output<string> NextSlot { get; set; }
}
```

## Task #2 - configure `active.slot` and `next.slot` values

```bash
cd base
pulumi config set active.slot blue
pulumi config set next.slot green
```

## Task #3 - deploy `base` Stack

```bash
pulumi up      
Previewing update (lab)

     Type                          Name          Plan
     pulumi:pulumi:Stack           ws4-base-lab
 +   └─ azure:frontdoor:Frontdoor  fd            create
 
Outputs:
  + ActiveSlot                : "blue"
  + NextSlot                  : "green"

Resources:
    + 1 to create
    3 unchanged

Do you want to perform this update? yes
Updating (lab)


     Type                          Name          Status
     pulumi:pulumi:Stack           ws4-base-lab
 +   └─ azure:frontdoor:Frontdoor  fd            created
 
Outputs:
  + ActiveSlot                : "blue"
    AppInsightConnectionString: "InstrumentationKey=..."
    InstrumentationKey        : "..."
  + NextSlot                  : "green"

Resources:
    + 1 created
    3 unchanged

Duration: 1m42s
```

## Task #4 - test Azure Front Door

```bash
curl --get -s https://iac-ws4-<YOUR-ID>-fd.azurefd.net/api/health
[lab-blue]: OK
```

## Next: implement master deployment script

[Go to lab-06](../lab-06/readme.md)
