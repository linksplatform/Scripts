#!/bin/bash

fetch_all_repositories() {
  local org="$1"
  local page=1
  local per_page=10  # Small page size to force pagination
  local temp_dir=$(mktemp -d)
  local repo_files=()
  
  echo "Fetching repositories for organization: $org" >&2
  
  while true; do
    echo "Fetching page $page..." >&2
    local response=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/orgs/$org/repos?per_page=$per_page&page=$page")
    
    if ! echo "$response" | jq . >/dev/null 2>&1; then
      echo "Invalid JSON response, stopping pagination" >&2
      break
    fi
    
    local repo_count=$(echo "$response" | jq length)
    if [ "$repo_count" -eq 0 ]; then
      break
    fi
    
    local page_file="${temp_dir}/page_${page}.json"
    echo "$response" > "$page_file"
    repo_files+=("$page_file")
    
    echo "Found $repo_count repositories on page $page" >&2
    
    if [ "$repo_count" -lt "$per_page" ]; then
      break
    fi
    
    page=$((page + 1))
  done
  
  if [ ${#repo_files[@]} -gt 0 ]; then
    jq -s 'add' "${repo_files[@]}"
    local total_repos=$(jq -s 'add | length' "${repo_files[@]}")
    echo "Total repositories found: $total_repos" >&2
  else
    echo "[]"
    echo "Total repositories found: 0" >&2
  fi
  
  rm -rf "$temp_dir"
}

repositories_json=$(fetch_all_repositories "$1")
echo "Final count: $(echo "$repositories_json" | jq length)" >&2
