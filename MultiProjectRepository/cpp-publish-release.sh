#!/bin/bash
set -e # Exit with nonzero exit code if anything failss

SEPARATOR="

"

if [ ! -f "CPP_PACKAGE_VERSION.txt" ]
then
    echo "CPP_PACKAGE_VERSION.txt not found."
    exit 1
fi

PACKAGE_VERSION=$(<CPP_PACKAGE_VERSION.txt)
PACKAGE_RELEASE_NOTES=$(<CPP_PACKAGE_RELEASE_NOTES.txt)
PACKAGE_URL="https://www.nuget.org/packages/Platform.$REPOSITORY_NAME.TemplateLibrary/$PACKAGE_VERSION"

TAG="$PACKAGE_VERSION"
RELEASE_NAME="[C++] $PACKAGE_VERSION"
RELEASE_BODY="$PACKAGE_URL$SEPARATOR$PACKAGE_RELEASE_NOTES"

publish-release.sh $TAG $RELEASE_NAME $RELEASE_BODY
