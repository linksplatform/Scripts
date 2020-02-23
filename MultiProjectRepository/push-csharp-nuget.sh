#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Pack NuGet package
dotnet pack -c Release

# Push NuGet package
dotnet nuget push ./**/*.nupkg -s https://api.nuget.org/v3/index.json --skip-duplicate -k "${NUGETTOKEN}" 

# Clean up
find . -type f -name '*.nupkg' -delete
find . -type f -name '*.snupkg' -delete
