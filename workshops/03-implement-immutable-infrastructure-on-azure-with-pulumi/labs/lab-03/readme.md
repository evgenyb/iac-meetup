# lab-03 - working with Stack Outputs

## Estimated completion time - ?? min

### Pulumi output

Here are some quotes collected from the original [documentation](https://www.pulumi.com/docs/intro/concepts/programming-model/#outputs).

>Resource properties are treated specially in Pulumi. All resource arguments accept inputs. Inputs are values of type Input<T> , a type that permits either a raw value of a given type (like string, integer, boolean etc...), an asynchronously computed value (i.e., a `Promise` or `Task`), or an output read from another resource’s properties.

>All resource properties on the instance object itself are outputs. Outputs are values of type Output<T> , which behave very much like promises; this is necessary because outputs are not fully known until the infrastructure resource has actually completed provisioning, which happens asynchronously. Outputs are also how Pulumi tracks dependencies between resources.

>Pulumi automatically captures dependencies when you pass an output from one resource as input to another, ensuring that physical infrastructure resources are not created or updated until all their dependencies are available and up-to-date.

>Because outputs are asynchronous, their actual raw values are not immediately available.

### Stack Outputs

From [documentation](https://www.pulumi.com/docs/intro/concepts/programming-model/#stack-outputs)

> A stack may export values as stack outputs. These outputs are shown during an update, can be easily retrieved from the Pulumi CLI, and are displayed in the Pulumi Console. They can be used for important values like resource IDs and computed IP addresses and DNS names. They can also be used for inter-stack dependencies, such as when a lower layer of infrastructure needs to export values for consumption elsewhere.

## Goals

* To learn and understand how Stack Outputs works

## Useful links

* [Pulumi: programming model](https://www.pulumi.com/docs/intro/concepts/programming-model/)
* [Pulumi: Inputs and Outputs](https://www.pulumi.com/docs/intro/concepts/programming-model/#outputs)
* [Pulumi: Stack Outputs](https://www.pulumi.com/docs/intro/concepts/programming-model/#stack-outputs)
* [Static website hosting in Azure Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website?WT.mc_id=AZ-MVP-5003837)

## Task #1 - create new project with Azure Storage account

```bash
$ mkdir lab-03
$ cd lab-03
$ pulumi new azure-csharp
```

Open project in IDE and refactor code to use `iac-ws3-lab4-rg` as resource group name and deploy it.

```bash
$ pulumi up
Previewing update (lab)

     Type                         Name           Plan       
 +   pulumi:pulumi:Stack          lab-03-lab     create     
 +   ├─ azure:core:ResourceGroup  resourceGroup  create     
 +   └─ azure:storage:Account     iacweb         create     
 
Resources:
    + 3 to create

Updating (lab)

     Type                         Name           Status      
 +   pulumi:pulumi:Stack          lab-03-lab     created     
 +   ├─ azure:core:ResourceGroup  resourceGroup  created     
 +   └─ azure:storage:Account     iacweb         created     
 
Outputs:
    ConnectionString: "..."

Resources:
    + 3 created

Duration: 32s
```

## Task #2 - add new `WebEndpoint` output property to expose Primary endpoint url  

You can serve static content (HTML, CSS, JavaScript, and image files) directly from a storage container named `$web`. Storage account uses `Primary endpoint` property to export the URL where static content is hosted, so we will use this property and expose it via Pulumi Output.

First, let's add new public property type of `Output<string>` called `WebEndpoint` and mark it with `Òutput` attribute. 

```c#
[Output]
public Output<string> WebEndpoint { get; set; }
```

Next, configure storage account `StaticWebsite` property

```c#
var storageAccount = new Account("iacweb", new AccountArgs
{
    ResourceGroupName = resourceGroup.Name,
    AccountReplicationType = "LRS",
    AccountTier = "Standard",
    StaticWebsite = new Pulumi.Azure.Storage.Inputs.AccountStaticWebsiteArgs
    {
        IndexDocument = "index.html"
    }
});
```

Finally, set this property right after Storage Account object is initialized.  

```c#
// Export the static website endpoint for the storage account
this.WebEndpoint = storageAccount.PrimaryWebEndpoint;
```

Now let's deploy it

```bash
$ pulumi up --yes
Previewing update (lab)

     Type                      Name        Plan       Info
     pulumi:pulumi:Stack       lab-03-lab             
 ~   └─ azure:storage:Account  iacweb      update     [diff: +staticWebsite]
 
Outputs:
  ~ ConnectionString: "..." => output<string>
  + WebEndpoint     : output<string>

Resources:
    ~ 1 to update
    2 unchanged

Updating (lab)

     Type                      Name        Status      Info
     pulumi:pulumi:Stack       lab-03-lab              
 ~   └─ azure:storage:Account  iacweb      updated     [diff: +staticWebsite]
 
Outputs:
    ConnectionString: "..."
  + WebEndpoint     : "https://iacweb607ffd9f.z6.web.core.windows.net/"

Resources:
    ~ 1 updated
    2 unchanged

Duration: 9s
```

As you can see, the `Outputs` section now shows `WebEndpoint` output that contains website endpoint URL.

If you try to access this webpage, you will get `The requested content does not exist`.

```bash
$ curl -s https://iacweb607ffd9f.z6.web.core.windows.net/
<!DOCTYPE html><html><head><title>WebContentNotFound</title></head><body><h1>The requested content does not exist.</h1><p><ul><li>HttpStatusCode: 404</li><li>ErrorCode: WebContentNotFound</li><li>RequestId : 3fe6c986-701e-0032-7eb7-9498bc000000</li><li>TimeStamp : 2020-09-27T10:16:08.7083353Z</li></ul></p></body></html>
```

This is because we haven't upload any files to the container yet and we will fix it later in further labs.

## Task #3 - add new `WebHost` output property to expose Primary web host

Add new `WebHost` property type off `Output<string>`, mark it with `[Output]` attribute and set it with the value from `storageAccount.PrimaryWebHost` property. Deploy the change and you should have output similar to this one:

```bash
$ pulumi up --yes
Previewing update (lab)

     Type                 Name        Plan     
     pulumi:pulumi:Stack  lab-03-lab           
 
Outputs:
  + WebHost         : "iacweb607ffd9f.z6.web.core.windows.net"

Resources:
    3 unchanged

Updating (lab)

     Type                 Name        Status     
     pulumi:pulumi:Stack  lab-03-lab             
 
Outputs:
    ConnectionString: "...."
    WebEndpoint     : "https://iacweb607ffd9f.z6.web.core.windows.net/"
  + WebHost         : "iacweb607ffd9f.z6.web.core.windows.net"

Resources:
    3 unchanged

Duration: 5s
```

## Task #4 - get Stack Outputs with CLI

From the CLI, you can use `pulumi stack output` to get all Outputs

```bash
$ pulumi stack output
Current stack outputs (3):
    OUTPUT            VALUE
    ConnectionString  ...
    WebEndpoint       https://iacweb607ffd9f.z6.web.core.windows.net/
    WebHost           iacweb607ffd9f.z6.web.core.windows.net
```

or you can get one specific output

```bash
$ pulumi stack output WebHost
iacweb607ffd9f.z6.web.core.windows.net
```

## Task #5 - cleanup

Destroy all resources

```bash
$ pulumi destroy --yes
```

## Next: persisting state at Azure Storage Account

[Go to lab-04](../lab-04/readme.md)
