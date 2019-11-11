#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt install nuget

# Get version string
PackageSpecFileNamePrefix="cpp/Platform.$REPOSITORY_NAME/NuGetPackageSource/Platform.$REPOSITORY_NAME.TemplateLibrary."
PackageSpecFileNameSuffix=".nuspec"
PackageSpecFileName=$(echo "$PackageSpecFileNamePrefix"*"$PackageSpecFileNameSuffix")
Version="${PackageSpecFileName#$PackageSpecFileNamePrefix}"
Version="${Version%$PackageSpecFileNameSuffix}"

# Ensure NuGet package does not exist
NuGetPackageUrl="https://globalcdn.nuget.org/packages/Platform.$REPOSITORY_NAME.TemplateLibrary.$Version.nupkg"
NuGetPackageUrl=$(echo "$NuGetPackageUrl" | tr '[:upper:]' '[:lower:]')
NuGetPageStatus="$(curl -Is "$NuGetPackageUrl" | head -1)"
StatusContents=( $NuGetPageStatus )
if [ "${StatusContents[1]}" == "200" ]; then
  echo "NuGet with current version is already pushed."
  exit 0
fi

# Ensure target directory exists
LibNativeIncludeDirectory="cpp/Platform.$REPOSITORY_NAME/NuGetPackageSource/lib/native/include"
mkdir -p "$LibNativeIncludeDirectory"

# Copy files
cp "cpp/Platform.$REPOSITORY_NAME/"*.h "$LibNativeIncludeDirectory/"
cp "cpp/Platform.$REPOSITORY_NAME/"*.cpp "$LibNativeIncludeDirectory/"

# Pack NuGet package
nuget pack "$PackageSpecFileName"

# Push NuGet package
nuget push ./**/*.nupkg -NoSymbols -Source https://api.nuget.org/v3/index.json -ApiKey "${NUGETTOKEN}" 

# Clean up
find . -type f -name '*.nupkg' -delete