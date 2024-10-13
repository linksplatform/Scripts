gh repo list linksplatform --limit 1000 | while read -r repo _; do
  repo_name=$(basename "$repo")
  if [ ! -d "$repo_name" ]; then
    gh repo clone "$repo" "$repo_name" -- --recurse-submodules
  else
    echo "Repository '$repo_name' already exists. Skipping clone."
  fi
done