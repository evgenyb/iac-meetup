#!/usr/bin/env bash

timestamp=`date "+%Y%m%d-%H%M%S"`

az group deployment create --template-file template.json -g iac-dev-rg -n "nsg-dev-${timestamp}" -o table