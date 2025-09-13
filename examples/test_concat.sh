#!/bin/bash

echo "Testing array concatenation..."

response1=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/linksplatform/repos?per_page=3&page=1")
response2=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/linksplatform/repos?per_page=3&page=2")

echo "Response 1 length: $(echo "$response1" | jq length)"
echo "Response 2 length: $(echo "$response2" | jq length)"

echo "Testing concatenation method 1:"
combined1=$(echo "$response1" "$response2" | jq -s 'add')
echo "Combined length method 1: $(echo "$combined1" | jq length)"

echo "Testing concatenation method 2:"
combined2=$(jq -n --argjson r1 "$response1" --argjson r2 "$response2" '$r1 + $r2')
echo "Combined length method 2: $(echo "$combined2" | jq length)"