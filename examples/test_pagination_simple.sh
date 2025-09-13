#!/bin/bash

echo "Testing pagination with per_page=10 to verify it works..."

org="linksplatform"
page=1
per_page=10
total_repos=0

echo "Fetching repositories for organization: $org"

while true; do
  echo "Fetching page $page..."
  response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/$org/repos?per_page=$per_page&page=$page")
  
  # Check if the response is valid JSON
  if ! echo "$response" | jq . >/dev/null 2>&1; then
    echo "Invalid JSON response on page $page, stopping"
    break
  fi
  
  repo_count=$(echo "$response" | jq length)
  echo "Found $repo_count repositories on page $page"
  
  if [ "$repo_count" -eq 0 ]; then
    echo "No more repositories found"
    break
  fi
  
  total_repos=$((total_repos + repo_count))
  
  # If we got fewer repositories than per_page, we've reached the end
  if [ "$repo_count" -lt "$per_page" ]; then
    echo "Last page reached (got $repo_count < $per_page)"
    break
  fi
  
  page=$((page + 1))
done

echo ""
echo "Total repositories found through pagination: $total_repos"

# Compare with single request
echo ""
echo "Comparing with single request (per_page=200):"
single_response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/$org/repos?per_page=200")
single_count=$(echo "$single_response" | jq length)
echo "Single request found: $single_count repositories"

if [ "$total_repos" -eq "$single_count" ]; then
  echo "SUCCESS: Both methods found the same number of repositories!"
else
  echo "ERROR: Different counts - pagination: $total_repos, single: $single_count"
fi