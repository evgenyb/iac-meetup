#!/usr/bin/env bash

rm -r ./publish
dotnet publish ../api.sln -c Release -o ./publish
