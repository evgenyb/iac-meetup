#!/usr/bin/env bash

cd ./01-nsg
./deploy.sh 
cd ../02-vnet
./deploy.sh 
cd ..