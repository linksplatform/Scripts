#!/bin/bash
# Make sure perl and jq are installed
repositories_json=$(curl "https://api.github.com/orgs/linksplatform/repos" -H "Accept: application/vnd.github.v3+json"); for clone_url_with_double_quotes in $( printf "${repositories_json}" | jq '.[] | .clone_url' ); do clone_url=$(printf ${clone_url_with_double_quotes} | perl -pe 's~"(?<clone_url>.*)"~$+{clone_url}~g'); git clone ${clone_url}; done;
