#!/usr/bin/env bash
#
# Usage:
# ./validate.sh dev-green

environment=$1
az group deployment validate -g iac-${environment}-rg --template-file template.json --parameters parameters-${environment}.json