#!/usr/bin/env bash
environment=$1

cd ./01-nsg
./deploy.sh ${environment}
cd ../02-vnet
./deploy.sh ${environment}
cd ..