#!/usr/bin/env bash

rm -r ./publish
rm ./api.zip
dotnet publish ../api.sln -c Release -o ./publish
cd ./publish
zip -r ../api.zip .
cd ..