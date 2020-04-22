#!/usr/bin/env bash

az group deployment validate --template-file template.json -g iac-dev-rg -o table