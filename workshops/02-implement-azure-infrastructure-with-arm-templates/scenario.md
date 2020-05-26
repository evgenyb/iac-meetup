# Today's use-case / scenario

![foo](images/infra.png)

* Use simple webapp with static content.
* Use Azure Storage Account static web feature to host our web site
* Use immutable infrastructure
* Use Front Door to orchestrate the traffic
* Use 2 environments: blue and green
* Active called active
* When we need to update infra, next environment will be called vNext
* First iteration active -> blue, vNext -> green
* Only one active endpoint in Front Door
* All changes to FrontDore are done via CI/CD

## Iteration 1 - initial provisioning -> blue as active environment

1. provision blue environment using CI/CD pipeline
2. provision Front Door with blue as an active endpoint
3. deploy webapp to active (blue) environment with CI/CD pipeline
4. test that webapp is accessible via FrontDoor

## Iteration 2 - switch to green

1. provision green environment using CI/CD pipeline
2. deploy webapp to vNext (green) environment with CI/CD pipeline
3. switch environment at Front Door configuration and do a switch by deploying changes to FD with CI/CD pipeline
4. test that webapp is accessible via FrontDoor
5. decommission blue storage account

## Iteration 3 - switch to blue

1. provision blue environment using CI/CD pipeline
2. deploy webapp to vNext (blue) environment with CI/CD pipeline
3. switch environment at Front Door configuration and do a switch by deploying changes to FD with CI/CD pipeline
4. test that webapp is accessible
5. decommission green storage account

## Repeat
