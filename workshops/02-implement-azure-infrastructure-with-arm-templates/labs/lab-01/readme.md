# Lab-01 - configure Azure DevOps

## Estimated completion time - 10 min

## Useful links

* [Use SSH key authentication](https://docs.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops&tabs=current-page)
* [Get started with Azure DevOps CLI](https://docs.microsoft.com/en-us/azure/devops/cli/?view=azure-devops)
* [Sign in with a Personal Access Token (PAT)](https://docs.microsoft.com/en-us/azure/devops/cli/log-in-via-pat?view=azure-devops&tabs=unix)
* [Create personal access tokens to authenticate access](https://docs.microsoft.com/en-gb/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&viewFallbackFrom=vsts&tabs=preview-page#create-personal-access-tokens-to-authenticate-access)

## Task 01 - configure your `az devops` environment

First, you need to [create personal access tokens (PAT) to authenticate access](https://docs.microsoft.com/en-gb/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&viewFallbackFrom=vsts&tabs=preview-page#create-personal-access-tokens-to-authenticate-access). Select 30 days token with `Full access`.

Next, set the `AZURE_DEVOPS_EXT_PAT` environment variable at the process level:

```bash
export AZURE_DEVOPS_EXT_PAT=xxxxxxxxxx
```

Replace xxxxxxxxxx with your PAT.

[sign to Azure DevOps with a Personal Access Token](https://docs.microsoft.com/en-us/azure/devops/cli/log-in-via-pat?view=azure-devops&tabs=unix).


