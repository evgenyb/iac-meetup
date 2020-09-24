# lab-06 - persisting state at Azure Storage Account

## Estimated completion time - ?? min

Pulumi stores its own copy of the current state of your infrastructure and there are two state backend options available:

* The Pulumi Service backend
* A self-managed backend, either stored locally on filesystem or remotely using a cloud storage service, in our case, Azure Blob Storage

Azure Blob Storage backend requires setting the following environment variables:

* AZURE_STORAGE_ACCOUNT 
* AZURE_STORAGE_KEY or AZURE_STORAGE_SAS_TOKEN.

## Goals

* Configure Pulumi to store state at Azure Storage Account


## Useful links

* [Pulumi: State and Backends](https://www.pulumi.com/docs/intro/concepts/state/)
* [Pulumi: Self-managed backends](https://www.pulumi.com/docs/intro/concepts/state/#self-managed-backends)
* [Using Pulumi on Azure Storage Accounts](https://cloud-right.com/2019/10/pulumi-azure-storage)
* [Storage account overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview?WT.mc_id=AZ-MVP-5003837)
* [Quickstart: Create, download, and list blobs with Azure CLI](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-cli?WT.mc_id=AZ-MVP-5003837)

## Task #1 - 

## Checkpoint

## Next: working with configuration and secrets

[Go to lab-07](../lab-07/readme.md)