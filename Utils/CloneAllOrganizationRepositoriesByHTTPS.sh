#!/bin/bash
# Make sure perl and jq are installed

repositories_json=$(curl -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/linksplatform/repos?per_page=100");

clone() {
  clone_url=$(printf ${clone_url_with_double_quotes} | perl -pe 's~"(?<clone_url>.*)"~$+{clone_url}~g');
  git clone ${clone_url};
}

for clone_url_with_double_quotes in $( printf "${repositories_json}" | jq '.[] | .clone_url' )
do
  clone &
done;
wait;
