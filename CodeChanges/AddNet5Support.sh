#!/bin/bash

# Use netcoreapp3.1 instead of netcoreapp3.0 (can be used separately)
find . -type f -name "*.csproj" -print0 | xargs -0 sed -i -e 's/netcoreapp3\.0/netcoreapp3.1/g'

# Use net5 instead of netcoreapp3.1 in automated tests
find . -type f -name "*.yml" -print0 | xargs -0 sed -i -e 's/dotnet test -c Release -f netcoreapp3.1/dotnet test -c Release -f net5/g'

# Add net5 target framework
find . -type f -name "*.csproj" -print0 | xargs -0 sed -i -e 's|netstandard2\.1<\/TargetFrameworks|netstandard2.1;net5<\/TargetFrameworks|g' -e 's|netcoreapp3\.1<\/TargetFrameworks|netcoreapp3.1;net5<\/TargetFrameworks|g' 

# Replace application's target framework
find . -type f -name "*.csproj" -print0 | xargs -0 sed -i -e 's|<TargetFramework>netcoreapp3\.1<\/TargetFramework>|<TargetFramework>net5<\/TargetFramework>|g'

# Remove .github folder from .gitignore
find . -type f -name ".gitignore" -print0 | xargs -0 sed -i -z -e 's|\n# GitHub refuses chages to \.github folder at the moment\n\.github\/\n||g'
