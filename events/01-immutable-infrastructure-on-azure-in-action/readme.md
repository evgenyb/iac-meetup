

## Initial infrastructure
* vnet /26
    * `agw-net` /27
    * `integration-net` /27
* ``webapp``
* ``api`` (dotnet core)
* CosmosDb
* AGW v1 with 2 rules:
    * /api  -> to api
    * /     -> to webapp
* AGW is deployed to ``agw-net`` subnet
* api uses vnet integration to `integration-net` subnet
* cosmosdb is only accessible via service endpoint towards `integration-net` subnet
* use ARM templates to provision infrastructure
* use Azure DevOps to build and deploy ``api`` and ``webapp``
* CNAME iac-dev.ifoobar.no -> cd964610-17f9-4a1d-a05b-91bec7d9048b.cloudapp.net

## New requirements
We need to upgrade AGW to v2.
### Challenges
* AGW v1 and AGW v2 can't be deployed to the same subnet, so we need to create new subnet
* We can't add new subnet, because we can't expand vnet address range, because of overlapping with ``aks-dev-vnet`` address range.

We need to re-provision all components and restructure vnet range. 
Let's introduce Traffic Manager 
```
./infra/scripts/misc/05-traffic-manager.sh dev
```
Now let's re-point DNS record towards 
```
./infra/scripts/misc/06-traffic-manager.sh dev
```

### iac-dev-blue-rg

