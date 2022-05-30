#!/bin/bash

# Use net6 instead of net5 in automated tests
find . -type f -name "*.yml" -print0 | xargs -0 sed -i -e 's/dotnet test -c Release -f net5/dotnet test -c Release -f net6/g'

# Add net6 target framework
find . -type f -name "*.csproj" -print0 | xargs -0 sed -i -e 's|net5<\/TargetFrameworks|net5;net6<\/TargetFrameworks|g' -e 's|net5.0<\/TargetFrameworks|net5;net6<\/TargetFrameworks|g'

# Replace application's target framework
find . -type f -name "*.csproj" -print0 | xargs -0 sed -i -e 's|<TargetFramework>net5<\/TargetFramework>|<TargetFramework>net6<\/TargetFramework>|g' -e 's|<TargetFramework>net5.0<\/TargetFramework>|<TargetFramework>net6<\/TargetFramework>|g'
