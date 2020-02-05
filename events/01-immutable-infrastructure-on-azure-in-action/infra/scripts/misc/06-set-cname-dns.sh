#!/usr/bin/env bash

environment=$1
tfmProfileName="iac-$environment-tfm"

# cd964610-17f9-4a1d-a05b-91bec7d9048b.cloudapp.net
#az network dns record-set cname set-record -g domains-and-certificates -z ifoobar.no  -n iac-dev -c cd964610-17f9-4a1d-a05b-91bec7d9048b.cloudapp.net --ttl 5
az network dns record-set cname set-record -g domains-and-certificates -z ifoobar.no  -n iac-dev -c ${tfmProfileName}.trafficmanager.net --ttl 5