#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt-get install nuget

PathToPackageSource="cpp/Platform.$REPOSITORY_NAME"

# Get version string
#PackageSpecFileNamePrefix="$PathToPackageSource/Platform.$REPOSITORY_NAME.TemplateLibrary."
#PackageSpecFileNameSuffix=".nuspec"
#PackageSpecFileName=$(echo "$PackageSpecFileNamePrefix"*"$PackageSpecFileNameSuffix")
PackageSpecFileName="$PathToPackageSource/$Platform.$REPOSITORY_NAME.TemplateLibrary.nuspec"
#Version="${PackageSpecFileName#$PackageSpecFileNamePrefix}"
#Version="${Version%$PackageSpecFileNameSuffix}"

# Ensure NuGet package does not exist
#NuGetPackageUrl="https://globalcdn.nuget.org/packages/Platform.$REPOSITORY_NAME.TemplateLibrary.$Version.nupkg"
#NuGetPackageUrl=$(echo "$NuGetPackageUrl" | tr '[:upper:]' '[:lower:]')
#NuGetPageStatus="$(curl -Is "$NuGetPackageUrl" | head -1)"
#StatusContents=( $NuGetPageStatus )
#if [ "${StatusContents[1]}" == "200" ]; then
#  echo "NuGet with current version is already pushed."
#  exit 0
#fi

# Pack NuGet package
nuget pack "$PackageSpecFileName"

# Push NuGet package
nuget push ./**/*.nupkg -NoSymbols -Source https://api.nuget.org/v3/index.json -ApiKey "${NUGETTOKEN}" 

# Clean up
find . -type f -name '*.nupkg' -delete
