#!/bin/bash

echo "Testing API response..."
response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/linksplatform/repos?per_page=2&page=1")

echo "Response length: ${#response}"
echo "First 200 characters:"
echo "$response" | head -c 200
echo ""
echo ""
echo "Testing jq parsing:"
echo "$response" | jq length