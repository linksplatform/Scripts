#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Use netcoreapp3.1 instead of netcoreapp3.0 (can be used separately)
find . -type f -name "*.csproj" -print0 | xargs -0 sed -i -e 's/netcoreapp3\.0/netcoreapp3.1/g'

# Use net5 instead of netcoreapp3.1 in automated tests
find . -type f -name "*.yml" -print0 | xargs -0 sed -i -e 's/dotnet test -c Release -f netcoreapp3.1/dotnet test -c Release -f net5/g'

# Add net5 target framework
find . -type f -name "*.csproj" -print0 | xargs -0 sed -i -e 's/netstandard2\.1</netstandard2.1;net5</g' -e 's/netcoreapp3.1</netcoreapp3.1;net5</g'
