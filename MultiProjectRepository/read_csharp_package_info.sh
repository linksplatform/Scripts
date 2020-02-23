#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt-get install xmlstarlet

export CSHARP_PACKAGE_PROJECT_PATH="csharp/Platform.$REPOSITORY_NAME/Platform.$REPOSITORY_NAME.csproj"
export CSHARP_PACKAGE_VERSION=$(xmlstarlet sel -t -m '//VersionPrefix[1]' -v . -n <"$CSHARP_PACKAGE_PROJECT_PATH")
export CSHARP_PACKAGE_RELEASE_NOTES=$(xmlstarlet sel -t -m '//PackageReleaseNotes[1]' -v . -n <"$CSHARP_PACKAGE_PROJECT_PATH")