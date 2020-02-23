#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Get version string
PackageFileNamePrefix="csharp/Platform.$REPOSITORY_NAME/bin/Release/Platform.$REPOSITORY_NAME."
PackageFileNameSuffix=".nupkg"
PackageFileName=$(echo "$PackageFileNamePrefix"*"$PackageFileNameSuffix")
Version="${PackageFileName#$PackageFileNamePrefix}"
Version="${Version%$PackageFileNameSuffix}"

# Ensure NuGet package does not exist
NuGetPackageUrl="https://globalcdn.nuget.org/packages/Platform.$REPOSITORY_NAME.$Version$PackageFileNameSuffix"
NuGetPackageUrl=$(echo "$NuGetPackageUrl" | tr '[:upper:]' '[:lower:]')

NuGetPageStatus="$(curl -Is "$NuGetPackageUrl" | head -1)"
StatusContents=( $NuGetPageStatus )
if [ "${StatusContents[1]}" == "200" ]; then
  echo "NuGet with current version is already pushed."
else
  echo "The NuGet package does not exist at $NuGetPackageUrl"

  # Pack NuGet package
  dotnet pack -c Release

  # Push NuGet package
  dotnet nuget push ./**/*.nupkg -s https://api.nuget.org/v3/index.json --skip-duplicate -k "${NUGETTOKEN}"
  
  # Clean up
  find . -type f -name '*.nupkg' -delete
  find . -type f -name '*.snupkg' -delete
fi
