#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt-get install xmlstarlet

CPP_PACKAGE_NUSPEC_PATH="cpp/Platform.$REPOSITORY_NAME/Platform.$REPOSITORY_NAME.TemplateLibrary.nuspec"
echo "$CPP_PACKAGE_NUSPEC_PATH"
echo "$CPP_PACKAGE_NUSPEC_PATH" > CPP_PACKAGE_NUSPEC_PATH.txt
CPP_PACKAGE_VERSION=$(xmlstarlet sel -t -m '///version[1]' -v . -n <"$CPP_PACKAGE_NUSPEC_PATH")
echo "$CPP_PACKAGE_VERSION"
echo "$CPP_PACKAGE_VERSION" > CPP_PACKAGE_VERSION.txt
CPP_PACKAGE_RELEASE_NOTES=$(xmlstarlet sel -t -m '///releaseNotes[1]' -v . -n <"$CPP_PACKAGE_NUSPEC_PATH")
echo "$CPP_PACKAGE_RELEASE_NOTES"
echo "$CPP_PACKAGE_RELEASE_NOTES" > CPP_PACKAGE_RELEASE_NOTES.txt
