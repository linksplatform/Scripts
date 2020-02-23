#!/bin/bash
set -e # Exit with nonzero exit code if anything failss

CSHARP_PACKAGE_VERSION=$(<CSHARP_PACKAGE_VERSION.txt)
CSHARP_PACKAGE_RELEASE_NOTES=$(<CSHARP_PACKAGE_RELEASE_NOTES.txt)

TAG_ID=$(curl --request GET --url "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/${CSHARP_PACKAGE_VERSION}" --header "authorization: Bearer ${GITHUB_TOKEN}" | jq -r '.id')

if [ "$TAG_ID" != "null" ]; then
    echo "Release with the same tag already published."
    exit 0
fi

SEPARATOR="

"
PACKAGE_RELEASE_NOTES_STRING=$(jq -saR . <<< "https://www.nuget.org/packages/Platform.$REPOSITORY_NAME/$CSHARP_PACKAGE_VERSION$SEPARATOR$CSHARP_PACKAGE_RELEASE_NOTES")
echo $PACKAGE_RELEASE_NOTES_STRING

curl --request POST \
--url "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" \
--header "authorization: Bearer ${GITHUB_TOKEN}" \
--header 'content-type: application/json' \
--data "{
  \"tag_name\": \"${CSHARP_PACKAGE_VERSION}\",
  \"target_commitish\": \"${DEFAULT_BRANCH}\",
  \"name\": \"${CSHARP_PACKAGE_VERSION}\",
  \"body\": $PACKAGE_RELEASE_NOTES_STRING,
  \"draft\": false,
  \"prerelease\": false
  }"
