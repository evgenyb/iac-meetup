#!/usr/bin/env bash

timestamp=`date "+%Y%m%d-%H%M%S"`

az group deployment create --template-file template.json -g iac-dev-rg -n "vnet-dev-${timestamp}" -o table