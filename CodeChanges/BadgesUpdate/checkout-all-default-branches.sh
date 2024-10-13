#!/bin/bash

# Loop through all directories in the current folder
for dir in */; do
    # Check if the directory is a git repository
    if [ -d "$dir/.git" ]; then
        echo "Processing $dir"
        cd "$dir"

        # Fetch the remote branches
        git fetch --all

        # Get the default branch (main or master)
        default_branch=$(git remote show origin | awk '/HEAD branch/ {print $NF}')

        # Checkout the default branch
        git checkout "$default_branch"

        # Pull the latest changes
        git pull origin "$default_branch"

        # Move back to the parent directory
        cd ..
    else
        echo "$dir is not a git repository, skipping."
    fi
done