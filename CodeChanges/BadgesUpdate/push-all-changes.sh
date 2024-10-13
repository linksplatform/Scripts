#!/bin/bash

# Prompt user for commit message once
read -p "Enter the commit message to use for all repositories: " commit_msg

# Iterate through all directories (assuming each directory is a Git repository)
for repo in */; do
    # Check if the directory contains a .git folder (indicating it's a Git repo)
    if [ -d "$repo/.git" ]; then
        echo "Checking repository: $repo"
        cd "$repo"
        
        # Check if there are uncommitted changes
        if [[ -n $(git status --porcelain) ]]; then
            echo "Uncommitted changes found in $repo."
            
            # Show git status and diff
            git status
            git --no-pager diff
            
            # Confirm whether to proceed with the changes
            read -p "Do you want to commit and push changes in $repo? (y/n): " confirm
            if [[ $confirm == "y" ]]; then
                # Add all changes, commit, and push
                git add .
                git commit -m "$commit_msg"
                git push
            else
                echo "Skipping $repo."
            fi
        else
            echo "No changes to commit in $repo."
        fi
        
        # Return to the parent directory
        cd ..
    else
        echo "$repo is not a Git repository."
    fi
done

echo "Script completed."