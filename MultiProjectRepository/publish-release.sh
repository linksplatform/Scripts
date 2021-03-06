#!/bin/bash
set -e # Exit with nonzero exit code if anything failss

SEPARATOR="

"

TAG_BUFFER=""
NAME_BUFFER=""
PACKAGE_RELEASE_NOTES_STRING_BUFFER=""

if [ -f "CSHARP_PACKAGE_VERSION.txt" ]; then
    CSHARP_PACKAGE_VERSION=$(<CSHARP_PACKAGE_VERSION.txt)
    CSHARP_PACKAGE_RELEASE_NOTES=$(<CSHARP_PACKAGE_RELEASE_NOTES.txt)
    CSHARP_PACKAGE_URL="https://www.nuget.org/packages/Platform.$REPOSITORY_NAME/$CSHARP_PACKAGE_VERSION"
    
    TAG_BUFFER="$CSHARP_PACKAGE_VERSION"
    NAME_BUFFER="[C#] $CSHARP_PACKAGE_VERSION"
    PACKAGE_RELEASE_NOTES_STRING_BUFFER="$CSHARP_PACKAGE_URL$SEPARATOR$CSHARP_PACKAGE_RELEASE_NOTES"
fi

if [ -f "CPP_PACKAGE_VERSION.txt" ]; then
    CPP_PACKAGE_VERSION=$(<CPP_PACKAGE_VERSION.txt)
    CPP_PACKAGE_RELEASE_NOTES=$(<CPP_PACKAGE_RELEASE_NOTES.txt)
    CPP_PACKAGE_URL="https://www.nuget.org/packages/Platform.$REPOSITORY_NAME.TemplateLibrary/$CPP_PACKAGE_VERSION"

    if [ -z "$TAG_BUFFER" ]; then
        TAG_BUFFER="$CPP_PACKAGE_VERSION"
        NAME_BUFFER="[C++] $CPP_PACKAGE_VERSION"
        PACKAGE_RELEASE_NOTES_STRING_BUFFER="$CPP_PACKAGE_URL$SEPARATOR$CPP_PACKAGE_RELEASE_NOTES"
    else
        TAG_BUFFER="${TAG_BUFFER}_$CPP_PACKAGE_VERSION"
        NAME_BUFFER="$NAME_BUFFER, [C++] $CPP_PACKAGE_VERSION"
        PACKAGE_RELEASE_NOTES_STRING_BUFFER="$PACKAGE_RELEASE_NOTES_STRING_BUFFER$SEPARATOR$SEPARATOR$CPP_PACKAGE_URL$SEPARATOR$CPP_PACKAGE_RELEASE_NOTES"
    fi
fi

TAG_ID=$(curl --request GET --url "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/${TAG_BUFFER}" --header "authorization: Bearer ${GITHUB_TOKEN}" | jq -r '.id')

if [ "$TAG_ID" != "null" ]; then
    echo "Release with the same tag already published."
    exit 0
fi

PACKAGE_RELEASE_NOTES_STRING=$(jq -saR . <<< "$PACKAGE_RELEASE_NOTES_STRING_BUFFER")
echo $PACKAGE_RELEASE_NOTES_STRING

curl --request POST \
--url "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" \
--header "authorization: Bearer ${GITHUB_TOKEN}" \
--header 'content-type: application/json' \
--data "{
  \"tag_name\": \"${TAG_BUFFER}\",
  \"target_commitish\": \"${DEFAULT_BRANCH}\",
  \"name\": \"${NAME_BUFFER}\",
  \"body\": $PACKAGE_RELEASE_NOTES_STRING,
  \"draft\": false,
  \"prerelease\": false
  }"
