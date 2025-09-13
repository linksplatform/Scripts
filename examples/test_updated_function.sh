#!/bin/bash

echo "Testing the updated fetch_all_repositories function..."

# Function to fetch all repositories with pagination support
fetch_all_repositories() {
  local org="$1"
  local page=1
  local per_page=100
  local all_repositories="[]"
  
  echo "Fetching repositories for organization: $org"
  
  while true; do
    echo "Fetching page $page..."
    local response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/$org/repos?per_page=$per_page&page=$page")
    
    # Check if the response is valid JSON and not empty
    if ! echo "$response" | jq . >/dev/null 2>&1; then
      echo "Invalid JSON response, stopping pagination"
      break
    fi
    
    local repo_count=$(echo "$response" | jq length)
    if [ "$repo_count" -eq 0 ]; then
      break
    fi
    
    # Append repositories to the collection using jq
    all_repositories=$(jq -n --argjson existing "$all_repositories" --argjson new "$response" '$existing + $new')
    
    echo "Found $repo_count repositories on page $page"
    
    # If we got fewer repositories than per_page, we've reached the end
    if [ "$repo_count" -lt "$per_page" ]; then
      break
    fi
    
    page=$((page + 1))
  done
  
  local total_repos=$(echo "$all_repositories" | jq length)
  echo "Total repositories found: $total_repos"
  
  echo "$all_repositories"
}

repositories_json=$(fetch_all_repositories "linksplatform")

echo ""
echo "Repository count: $(echo "$repositories_json" | jq length)"

echo ""
echo "First 5 repository names:"
echo "$repositories_json" | jq -r '.[0:5] | .[] | .name'

echo ""
echo "Last 5 repository names:"  
echo "$repositories_json" | jq -r '.[-5:] | .[] | .name'