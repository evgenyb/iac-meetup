# lab-03 - implement simple Azure Function

## Estimated completion time - xx min

In this lab we will implement simple Azure Function API using HTTP trigger that lets you invoke a function with an HTTP request. API will return response, containing value of environment variable `ENVIRONMENT_NAME'. This variable will contain the name of the current environment and will be set at the provisioning time.

## Goals

* Implement simple dotnet Azure Function API with C# using HTTP trigger
* Test Azure function locally

## Useful links

* [Azure Functions HTTP trigger](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-http-webhook-trigger?WT.mc_id=AZ-MVP-5003837?tabs=csharp)
* [Azure Functions documentation](https://docs.microsoft.com/en-us/azure/azure-functions?WT.mc_id=AZ-MVP-5003837)
* [Install the Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?WT.mc_id=AZ-MVP-5003837?tabs=linux%2Ccsharp%2Cbash#install-the-azure-functions-core-tools)
* [Work with Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?WT.mc_id=AZ-MVP-5003837?tabs=windows%2Ccsharp%2Cbash#v2)
* [dotnet publish](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-publish?WT.mc_id=AZ-MVP-5003837)

## Task 1 - installing Azure Func SDK

### Windows

[Download](https://go.microsoft.com/fwlink/?linkid=2135274) and run the Core Tools installer, based on your version of Windows.

### Ubuntu

```bash
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
sudo apt-get update
sudo apt-get install azure-functions-core-tools-3
```

## Task #2 - create new Azure Function Project

Now, you can create Azure Function for `dotnet` runtime with `C#` as a language. We will use `Http Trigger` so that we can trigger function with HTTP requests and function will return value of `ENVIRONMENT_NAME` environment variable.

```bash
cd ..
func init function --worker-runtime dotnet
cd function
func new -n health -t "Http Trigger" -l "C#"
```

Here is my implementation of `health.cs` file:

```c#
using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace function
{
    public static class health
    {
        [FunctionName("health")]
        public static async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get",  Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation("C# HTTP trigger function processed a request.");

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            var responseMessage = $"[{Environment.GetEnvironmentVariable("ENVIRONMENT_NAME", EnvironmentVariableTarget.Process)}]: OK";

            return new OkObjectResult(responseMessage);
        }
    }
}
```

Set environment variable `ENVIRONMENT_NAME` with some test value

```bash
export ENVIRONMENT_NAME=lab
```

or, if you use PowerShell

```powershell
$Env:ENVIRONMENT_NAME="lab"
```

Try to run function locally

```bash
func start --build
Microsoft (R) Build Engine version 16.7.0+7fb82e5b2 for .NET
Copyright (C) Microsoft Corporation. All rights reserved.

  Determining projects to restore...
  Restored C:\temp\ws4-dr1\function\function.csproj (in 3,97 sec).
  function -> C:\temp\ws4-dr1\function\bin\output\bin\function.dll

Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:11.50


Azure Functions Core Tools (3.0.2931 Commit hash: d552c6741a37422684f0efab41d541ebad2b2bd2)
Function Runtime Version: 3.0.14492.0
Hosting environment: Production
Content root path: C:\temp\ws4-dr1\function\bin\output
Now listening on: http://0.0.0.0:7071
Application started. Press Ctrl+C to shut down.

Functions:

        health: [GET] http://localhost:7071/api/health
```

And you can test it with `curl`

```bash
$ curl --get http://localhost:7071/api/health
[lab]: OK
```

## Task #3 - publish Azure function to the `published` folder

Let's publish our Azure function and its dependencies with `dotnet publish` command to `../published` folder. These artifacts will be used in the next lab.

```bash
$dotnet publish function.csproj --self-contained true -c Release  -o ../published
Microsoft (R) Build Engine version 16.7.0+7fb82e5b2 for .NET
Copyright (C) Microsoft Corporation. All rights reserved.

  Determining projects to restore...
  All projects are up-to-date for restore.
  function -> C:\temp\ws4-dr1\function\bin\Release\netcoreapp3.1\bin\function.dll
  function -> C:\temp\ws4-dr1\published\
```

## Next: add Azure Function infrastructure into the workload stack

[Go to lab-04](../lab-04/readme.md)
