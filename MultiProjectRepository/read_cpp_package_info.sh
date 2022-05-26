#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

CPP_PACKAGE_NUSPEC_PATH="Platform.$REPOSITORY_NAME/Platform.$REPOSITORY_NAME.TemplateLibrary.nuspec"
echo "$CPP_PACKAGE_NUSPEC_PATH"
echo "$CPP_PACKAGE_NUSPEC_PATH" > CPP_PACKAGE_NUSPEC_PATH.txt
CPP_PACKAGE_VERSION=$(grep -Pzo "<version>[^<>]+</version>" "$CPP_PACKAGE_NUSPEC_PATH" | sed -e 's/<.\?[a-zA-Z]\+>//g' | tr -d '\0')
echo "$CPP_PACKAGE_VERSION"
echo "$CPP_PACKAGE_VERSION" > CPP_PACKAGE_VERSION.txt
CPP_PACKAGE_RELEASE_NOTES=$(grep -Pzo "<releaseNotes>[^<>]+</releaseNotes>" "$CPP_PACKAGE_NUSPEC_PATH" | sed -e 's/<.\?[a-zA-Z]\+>//g' | tr -d '\0')
echo "$CPP_PACKAGE_RELEASE_NOTES"
echo "$CPP_PACKAGE_RELEASE_NOTES" > CPP_PACKAGE_RELEASE_NOTES.txt
