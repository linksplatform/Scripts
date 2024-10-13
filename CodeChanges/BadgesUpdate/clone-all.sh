gh repo list linksplatform --limit 1000 | while read -r repo _; do
  repo_name=$(basename "$repo")
  
  # Check if the repository is already cloned
  if [ ! -d "$repo_name" ]; then
    # Get the default branch of the repository
    default_branch=$(gh repo view "$repo" --json defaultBranchRef -q ".defaultBranchRef.name")

    # Clone the repository with the default branch and shallow depth
    gh repo clone "$repo" "$repo_name" -- --depth 1 --branch "$default_branch" --single-branch
  else
    echo "Repository '$repo_name' already exists. Skipping clone."
  fi
done