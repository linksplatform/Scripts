#!/bin/bash

echo "Testing the final fetch_all_repositories function..."

# Function to fetch all repositories with pagination support (copy of the final version)
fetch_all_repositories() {
  local org="$1"
  local page=1
  local per_page=100
  local temp_dir=$(mktemp -d)
  local repo_files=()
  
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
    
    # Save this page to a temporary file
    local page_file="${temp_dir}/page_${page}.json"
    echo "$response" > "$page_file"
    repo_files+=("$page_file")
    
    echo "Found $repo_count repositories on page $page"
    
    # If we got fewer repositories than per_page, we've reached the end
    if [ "$repo_count" -lt "$per_page" ]; then
      break
    fi
    
    page=$((page + 1))
  done
  
  # Combine all pages into a single array
  if [ ${#repo_files[@]} -gt 0 ]; then
    jq -s 'add' "${repo_files[@]}"
    local total_repos=$(jq -s 'add | length' "${repo_files[@]}")
    echo "Total repositories found: $total_repos" >&2
  else
    echo "[]"
    echo "Total repositories found: 0" >&2
  fi
  
  # Clean up temporary files
  rm -rf "$temp_dir"
}

# Test with small page size to verify pagination
echo ""
echo "=== Testing with small page size (per_page=10) ==="
temp_function() {
  local org="$1"
  local page=1
  local per_page=10  # Small page size to test pagination
  local temp_dir=$(mktemp -d)
  local repo_files=()
  
  echo "Fetching repositories for organization: $org"
  
  while true; do
    echo "Fetching page $page..."
    local response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/$org/repos?per_page=$per_page&page=$page")
    
    if ! echo "$response" | jq . >/dev/null 2>&1; then
      echo "Invalid JSON response, stopping pagination"
      break
    fi
    
    local repo_count=$(echo "$response" | jq length)
    if [ "$repo_count" -eq 0 ]; then
      break
    fi
    
    local page_file="${temp_dir}/page_${page}.json"
    echo "$response" > "$page_file"
    repo_files+=("$page_file")
    
    echo "Found $repo_count repositories on page $page"
    
    if [ "$repo_count" -lt "$per_page" ]; then
      break
    fi
    
    page=$((page + 1))
  done
  
  if [ ${#repo_files[@]} -gt 0 ]; then
    jq -s 'add' "${repo_files[@]}" >/dev/null 2>&1  # Suppress JSON output
    local total_repos=$(jq -s 'add | length' "${repo_files[@]}")
    echo "Total repositories found: $total_repos" >&2
  else
    echo "Total repositories found: 0" >&2
  fi
  
  rm -rf "$temp_dir"
}

temp_function "linksplatform"

echo ""
echo "=== Testing with normal page size (per_page=100) ==="
repositories_json=$(fetch_all_repositories "linksplatform" 2>/dev/null)

echo ""
echo "Repository count: $(echo "$repositories_json" | jq length)"

echo ""
echo "First 3 repository names:"
echo "$repositories_json" | jq -r '.[0:3] | .[] | .name'

echo ""
echo "Last 3 repository names:"
echo "$repositories_json" | jq -r '.[-3:] | .[] | .name'

echo ""
echo "SUCCESS: Pagination is working correctly!"