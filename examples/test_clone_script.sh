#!/bin/bash
# Make sure curl, perl and jq are installed

if [ -z "$1" ]
then
  echo "Organization name is required. It should be the first argument."
  exit 1
fi

# Function to fetch all repositories with pagination support
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

clone() {
  clone_url=$(printf ${clone_url_with_double_quotes} | perl -pe 's~"(?<clone_url>.*)"~$+{clone_url}~g');
  echo "Cloning $clone_url_with_double_quotes..."
  echo "Would clone: ${clone_url}";
  echo "Done cloning $clone_url_with_double_quotes."
}

# Fetch all repositories using pagination
repositories_json=$(fetch_all_repositories "$1")

for clone_url_with_double_quotes in $( printf "${repositories_json}" | jq '.[] | .clone_url' )
do
  clone
done;
wait;
