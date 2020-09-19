# Implement immutable infrastructure with Pulumi

Welcome to the third workshop at the series of workshop dedicated to Infrastructure as Code tools and frameworks. During the first 2 workshops we learned what are ARM templates and how to use them. This time we will look at Pulumi - an open source infrastructure as code tool for creating, deploying, and managing cloud infrastructure.

The original plan was to implement 2 workshops per tool: 

1. Get started with the `tool`
2. Implement immutable infrastructure on Azure with `tool`

 But it turned out that Pulumi is so easy to work with, that I decided to merge both workshops into one.

## Prerequisites

Please ensure you have completed the Workshop [prerequisites](prerequisites.md)

## Workshop goals

The goals for this workshop are:

* get started with Pulumi on Azure
* learn how to use Azure services like Storage Account and Key Vault  to self-manage the state and secrets management
* implement immutable infrastructure on Azure 
* create an configure set of CI/CD pipelines for infrastructure provisioning and deployment

## Agenda

* 17:05 - 17:10 - welcome + practical info
* 17:10 - 17:15 - MS Azure Badges
* Infrastructure as Code
* Pulumi 101
* lab-01 - create new Pulumi project (xx min)
* lab-02 - work with pulumi "flow" (xx min)
* lab-03 - working with stack (xx min)
* lab-04 - working with stack Outputs (xx min)
* lab-05 - pulumi state and backends (xx min)
* lab-06 - persisting state at Azure Storage Account (xx min)
* lab-07 - working with configuration and secrets (xx min)
* lab-08 - managing Secrets with Azure Key-Vault (xx min)
* lab-09 - import existing resources (xx min)
* Immutable Infrastructure + use-case introduction
* lab-10 - implement `blue` static website using Azure Blob Storage (xx min)
* lab-11 - clone `green` static website using Azure Blob Storage (xx min)
* lab-12 - implement Azure FrontDoor to orchestrate canary traffic between `blue` / `green` slots  (xx min)

## Links

* [Pulumi](https://www.pulumi.com/)
* [Pulumi: Get Started with Azure](https://www.pulumi.com/docs/get-started/azure/)
* [Storage account overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview?WT.mc_id=AZ-MVP-5003837)
* [About Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/overview?WT.mc_id=AZ-MVP-5003837)
