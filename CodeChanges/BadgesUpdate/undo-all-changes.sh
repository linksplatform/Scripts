#!/bin/bash

# Function to reset and clean the repository
reset_repo() {
    echo "Resetting repository in $(pwd)"
    git reset --hard      # Undo all uncommitted changes to tracked files
    git clean -fd         # Remove untracked files and directories
}

# Loop through all directories and look for .git folder
for dir in */ ; do
    if [ -d "$dir/.git" ]; then
        cd "$dir"         # Enter the repository
        reset_repo        # Call the reset function
        cd ..             # Go back to the original directory
    fi
done

echo "All repositories have been reset."