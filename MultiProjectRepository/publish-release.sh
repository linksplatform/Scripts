#!/bin/bash

TAG=$1
RELEASE_NAME=$2
RELEASE_BODY=$3

echo "Repository name: $GITHUB_REPOSITORY";
echo "Tag: $TAG";
echo "Default branch: $DEFAULT_BRANCH";
echo "Release name: $RELEASE_NAME";
echo "Release body: $RELEASE_BODY";

tag_id=$(curl --request GET --url "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/${TAG}" --header "authorization: Bearer ${GITHUB_TOKEN}" | jq -r '.id')

if [ "$tag_id" != "null" ]; then
    echo "Release with the same TAG already published."
    exit 0
fi

RELEASE_BODY_STRING=$(jq -saR . <<< "$RELEASE_BODY")
echo "RELEASE_BODY_STRING: $RELEASE_BODY_STRING"

curl --request POST \
--url "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" \
--header "authorization: Bearer ${GITHUB_TOKEN}" \
--header 'content-type: application/json' \
--data "{
  \"tag_name\": \"${TAG}\",
  \"target_commitish\": \"${DEFAULT_BRANCH}\",
  \"name\": \"${RELEASE_NAME}\",
  \"body\": $RELEASE_BODY_STRING,
  \"draft\": false,
  \"prerelease\": false
  }"