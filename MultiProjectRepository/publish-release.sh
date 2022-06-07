#!/bin/bash

TAG=$1
RELEASE_NAME=$2
RELEASE_BODY=$3

echo "Repository name: $GITHUB_REPOSITORY";
echo "Tag: $TAG";
echo "Default branch: $DEFAULT_BRANCH";
echo "Release name: $RELEASE_NAME";
echo "Release body: $RELEASE_BODY";

TAG_ID=$(curl --request GET --url "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/${TAG}" --header "authorization: Bearer ${GITHUB_TOKEN}" | jq -r '.id')

if [ "$TAG_ID" != "null" ]; then
    echo "Release with the same TAG already published."
    exit 0
fi

RELEASE_BODY_STRING=$(jq -saR . <<< "$RELEASE_BODY")
echo "RELEASE_BODY_STRING: $RELEASE_BODY_STRING"

zip -r "Platform.${RELEASE_NAME}.zip" "Platform.${RELEASE_NAME}"
gh release create "${TAG}" "Platform.${RELEASE_NAME}.zip" -t "${RELEASE_NAME}" -n "${RELEASE_BODY_STRING}"
