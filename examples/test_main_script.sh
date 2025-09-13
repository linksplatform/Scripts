#!/bin/bash

echo "Testing the main script without actually cloning..."

# Create a modified version that just lists repositories instead of cloning
cd /tmp/gh-issue-solver-1757725240169

# Test the fetch_all_repositories function
source Utils/CloneAllOrganizationRepositoriesByHTTPS.sh

echo "Testing fetch_all_repositories function..."
repositories_json=$(fetch_all_repositories "linksplatform")

echo ""
echo "Repository count: $(echo "$repositories_json" | jq length)"

echo ""
echo "First 5 repository names:"
echo "$repositories_json" | jq -r '.[0:5] | .[] | .name'

echo ""
echo "Last 5 repository names:"
echo "$repositories_json" | jq -r '.[-5:] | .[] | .name'

echo ""
echo "Sample clone URLs:"
echo "$repositories_json" | jq -r '.[0:3] | .[] | .clone_url'