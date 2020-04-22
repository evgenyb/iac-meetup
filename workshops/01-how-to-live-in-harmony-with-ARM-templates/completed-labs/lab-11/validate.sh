#!/usr/bin/env bash
environment=$1

cd ./01-nsg
./validate.sh ${environment}
cd ../02-vnet
./validate.sh ${environment}
cd ..