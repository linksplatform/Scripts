#!/bin/bash
# Make sure curl, perl and jq are installed

if [ -z "$1" ]
then
  echo "Organization name is required. It should be the first argument."
  exit 1
fi

repositories_json=$(curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/$1/repos?per_page=200");

clone() {
  clone_url=$(printf ${clone_url_with_double_quotes} | perl -pe 's~"(?<clone_url>.*)"~$+{clone_url}~g');
  echo "Cloning $clone_url_with_double_quotes..."
  git clone --depth 1 --recurse-submodules -j8 ${clone_url};
  echo "Done cloning $clone_url_with_double_quotes."
}

for clone_url_with_double_quotes in $( printf "${repositories_json}" | jq '.[] | .clone_url' )
do
  clone
done;
wait;
