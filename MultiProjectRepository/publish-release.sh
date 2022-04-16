#!/bin/bash

repository_name=$1
tag=$2
github_token=$3
default_branch_name=$4
release_name=$5
release_body=$6

echo "Repository name: $release_name";
echo "tag: $tag";
echo "Default branch: $default_branch_name";
echo "Release name: $release_name";
echo "Release body: $release_body";

tag_id=$(curl --request GET --url "https://api.github.com/repos/${repository_name}/releases/tags/${tag}" --header "authorization: Bearer ${github_token}" | jq -r '.id')

if [ "$tag_id" != "null" ]; then
    echo "Release with the same tag already published."
    exit 0
fi

PACKAGE_RELEASE_NOTES_STRING=$(jq -saR . <<< "$PACKAGE_RELEASE_NOTES_STRING_BUFFER")
echo $PACKAGE_RELEASE_NOTES_STRING

curl --request POST \
--url "https://api.github.com/repos/$repository_name/releases" \
--header "authorization: Bearer ${github_token}" \
--header 'content-type: application/json' \
--data "{
  \"tag_name\": \"${tag}\",
  \"target_commitish\": \"${default_branch_name}\",
  \"name\": \"${release_name}\",
  \"body\": $release_body,
  \"draft\": false,
  \"prerelease\": false
  }"