# Implement immutable infrastructure with Pulumi: Part II

Welcome to the forth workshop at the series of workshops dedicated to Infrastructure as Code tools and frameworks. 
[Last time](https://github.com/evgenyb/iac-meetup/tree/master/workshops/03-implement-immutable-infrastructure-on-azure-with-pulumi) we worked with `Pulumi` basics and learned how to work with Stacks, Configuration and secrets, how to deploy and destroy stacks and how to use inter-stack dependencies. 
This time, we will use this knowledge and implement simple immutable infrastructure with automated CI/CD pipelines.

## Prerequisites

Please ensure you have completed the Workshop [prerequisites](prerequisites.md)

## Workshop goals

* design and implement a simple immutable infrastructure using Pulumi
* create an configure set of CI/CD pipelines for infrastructure provisioning and application deployment

## Workshop use-case

During the workshop, we will implement very simple system that consists of Azure Function with Azure Front Door in front to orchestrate the traffic. Even though the setup looks simple, it will still give us enough challenges to get a good hands-on experience working with Pulumi.

![logo](images/ws-logo.png)

## Agenda (this is subject to change)

* 17:05 - 17:10 - welcome + practical info
* 17:10 - 17:15 - Microsoft Azure Heroes program
* Use-case introduction
* lab-01 - setting up the project and stacks structure
* lab-02 - implement AppInsight into the base stack
* lab-03 - implement simple Azure Function
* lab-04 - implement Azure Function infrastructure into the workload stack
* lab-05 - implement Azure Front Door infrastructure into the base stack
* lab-06 - implement deployment orchestration script

CI/CD with Azure DevOps
* lab-07 - configure build pipeline for Azure Function
* lab-08 - configure release pipeline