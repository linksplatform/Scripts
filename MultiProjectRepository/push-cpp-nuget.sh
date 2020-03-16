#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt-get install nuget

CPP_PACKAGE_NUSPEC_PATH=$(<CPP_PACKAGE_NUSPEC_PATH.txt)
CPP_PACKAGE_NUSPEC_DIRECTORY=$(dirname "$CPP_PACKAGE_NUSPEC_PATH")
CPP_PACKAGE_VERSION=$(<CPP_PACKAGE_VERSION.txt)

# Ensure NuGet package does not exist
NuGetPackageUrl="https://globalcdn.nuget.org/packages/Platform.$REPOSITORY_NAME.TemplateLibrary.$CPP_PACKAGE_VERSION.nupkg"
NuGetPackageUrl=$(echo "$NuGetPackageUrl" | tr '[:upper:]' '[:lower:]')
NuGetPageStatus="$(curl -Is "$NuGetPackageUrl" | head -1)"
StatusContents=( $NuGetPageStatus )
if [ "${StatusContents[1]}" == "200" ]; then
  echo "NuGet with current version is already pushed."
  exit 0
fi

# Download icon.png for the package
wget -O "$CPP_PACKAGE_NUSPEC_DIRECTORY/icon.png" https://raw.githubusercontent.com/linksplatform/Documentation/18469f4d033ee9a5b7b84caab9c585acab2ac519/doc/Avatar-rainbow-icon-64x64.png

# Pack NuGet package
nuget pack "$CPP_PACKAGE_NUSPEC_PATH"

# Push NuGet package
nuget push ./**/*.nupkg -NoSymbols -Source https://api.nuget.org/v3/index.json -ApiKey "${NUGETTOKEN}" 

# Clean up
find . -type f -name '*.nupkg' -delete
