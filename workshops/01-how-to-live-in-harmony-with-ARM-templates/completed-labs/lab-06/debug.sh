#!/usr/bin/env bash

az group deployment create -g iac-dev-rg --template-file template.json --verbose