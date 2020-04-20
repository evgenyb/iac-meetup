# lab-06 - tips and tricks, how to use output for debugging ARM templates

## Task #1 - cerate an empty ARM template

For this lab we don't need any resources, because we will not deploy anything, therefore create an dummy ARM template file called `template.json` without any resources.

Create new script called `debug.sh` with deployment command
(use powershell equivalent if you use PS)

```bash
az group deployment create -g iac-dev-rg --template-file template.json --verbose
```

The output of this command will look something like that:

```txt
$ az group deployment create -g iac-dev-rg --template-file template.json
{
  "id": "/subscriptions/<your-subscription-id>/resourceGroups/iac-dev-rg/providers/Microsoft.Resources/deployments/template",
  "location": null,
  "name": "template",
  "properties": {
    "correlationId": "<correlation-id>",
    "debugSetting": null,
    "dependencies": [],
    "duration": "PT0.501499S",
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [],
    "outputs": {},
    "parameters": null,
   ...
```

You can find field called `outputs`. It's empty, because we didn't implemented any output object. But when you add outputs, you will find them in that section of tou deployment command output.

Note, you shouldn't use `-o table` or other parameters for the `az group deployment create` command, otherwise you will not be able to find `outputs` section.

## Task #2 - compose variable with `concat` function and print it's value to ARM template `outputs`

Create new variable called `environment` with value `dev`. Create new variable `nsgName` and build it's value by using `concat` function and following pattern `iac-{environment}-aks-nsg`. Create new `outputs` object called `nsgName` type of `string` with value from `nsgName` variable.

Debug your template and check the output section for the values

```bash
./debug.sh
```


## Task #3 - print current resource group location to ARM template `outputs`

Create new `outputs` object called `inherited_loaction` type of `string`. Use `resourceGroup` function and print current resource group location.

Debug your template and check the output section for the values

```bash
./debug.sh
```

## Task #4 - print network security group iac-dev-aks resource id to ARM template `outputs`

Create new `outputs` object called `aks-nsg-resource-id` type of `string`. Use `resourceId` function to print `iac-dev-aks` nsg resource id.

Debug your template and check the output section for the values

```bash
./debug.sh
```

## Useful links

* [Outputs in Azure Resource Manager template](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-outputs?tabs=azure-powershell)
* [resourceId function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#resourceid)
* [resourceGroup](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-resource#resourcegroup)
* [concat function](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-functions-string#concat)

## Next

[Go to lab-07](../lab-07/readme.md)
