open Farmer
open Farmer.Builders
open IacCore

[<EntryPoint>]
let main argv =
    let environment = argv.[0]
    
    let storageAccountName = NamingConventions.GetStorageAccountName ("diagnostics", environment)

    let sa = storageAccount {
        name storageAccountName  
    }

    let functionName = NamingConventions.GetFunctionName ("poc", environment)
    let servicePlanName = NamingConventions.GetServicePlanName (environment)
    
    let func = functions {
        name functionName
        service_plan_name servicePlanName
        setting "storage_key" sa.Key
        link_to_storage_account storageAccountName
        https_only
        app_insights_off
        add_tag "owner" "team-platform"
    }

    let deployment = arm {
        location Location.WestEurope
        add_resource sa
        add_resource func
    }

    let resourceGroupName = NamingConventions.GetResourceGroupName(environment)
    printf "Trying to deploy to resource group %s ..." resourceGroupName
    let response =
        deployment
        |> Deploy.tryExecute resourceGroupName Deploy.NoParameters
        |> function
        | Ok outputs -> sprintf "Success! Outputs: %A" outputs
        | Error error -> sprintf "Rejected! %A" error

    printfn "Deployment finished with result: %s" response

    0
