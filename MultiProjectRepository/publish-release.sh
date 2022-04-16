#!/bin/bash

tag=$1
release_name=$2
release_body=$3

echo "Repository name: $REPOSITORY_NAME";
echo "tag: $tag";
echo "Default branch: $DEFAULT_BRANCH";
echo "Release name: $release_name";
echo "Release body: $release_body";

tag_id=$(curl --request GET --url "https://api.github.com/repos/${REPOSITORY_NAME}/releases/tags/${tag}" --header "authorization: Bearer ${GITHUB_TOKEN}" | jq -r '.id')

if [ "$tag_id" != "null" ]; then
    echo "Release with the same tag already published."
    exit 0
fi

PACKAGE_RELEASE_NOTES_STRING=$(jq -saR . <<< "$PACKAGE_RELEASE_NOTES_STRING_BUFFER")
echo $PACKAGE_RELEASE_NOTES_STRING

curl --request POST \
--url "https://api.github.com/repos/$REPOSITORY_NAME/releases" \
--header "authorization: Bearer ${GITHUB_TOKEN}" \
--header 'content-type: application/json' \
--data "{
  \"tag_name\": \"${tag}\",
  \"target_commitish\": \"${DEFAULT_BRANCH}\",
  \"name\": \"${release_name}\",
  \"body\": $release_body,
  \"draft\": false,
  \"prerelease\": false
  }"