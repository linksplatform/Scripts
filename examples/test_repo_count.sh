#!/bin/bash

echo "Testing repository count with different methods..."

echo ""
echo "1. Using the original method (single request with per_page=200):"
original_response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/linksplatform/repos?per_page=200")
original_count=$(echo "$original_response" | jq length)
echo "Original method found: $original_count repositories"

echo ""
echo "2. Using pagination with per_page=100:"

# Function to fetch all repositories with pagination support
fetch_all_repositories() {
  local org="$1"
  local page=1
  local per_page=100
  local all_repositories=""
  local total_fetched=0
  
  while true; do
    local response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/$org/repos?per_page=$per_page&page=$page")
    
    # Check if the response is valid JSON and not empty
    if ! echo "$response" | jq . >/dev/null 2>&1; then
      echo "Invalid JSON response on page $page, stopping pagination"
      break
    fi
    
    local repo_count=$(echo "$response" | jq length)
    if [ "$repo_count" -eq 0 ]; then
      echo "No more repositories found on page $page"
      break
    fi
    
    # Append repositories to the collection
    if [ -z "$all_repositories" ]; then
      all_repositories="$response"
    else
      all_repositories=$(echo "$all_repositories" "$response" | jq -s 'add')
    fi
    
    total_fetched=$((total_fetched + repo_count))
    echo "Page $page: found $repo_count repositories (total so far: $total_fetched)"
    
    # If we got fewer repositories than per_page, we've reached the end
    if [ "$repo_count" -lt "$per_page" ]; then
      echo "Last page reached (got $repo_count < $per_page)"
      break
    fi
    
    page=$((page + 1))
  done
  
  local final_count=$(echo "$all_repositories" | jq length)
  echo "Final count from pagination: $final_count repositories"
  
  echo "$all_repositories"
}

repositories_json=$(fetch_all_repositories "linksplatform")

echo ""
echo "3. Comparison:"
new_count=$(echo "$repositories_json" | jq length)
echo "Original method: $original_count repositories"
echo "New method: $new_count repositories"

if [ "$new_count" -gt "$original_count" ]; then
  echo "SUCCESS: New method found more repositories!"
  echo "Difference: $((new_count - original_count)) additional repositories"
else
  echo "Both methods found the same number of repositories."
fi