#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

sudo apt-get install nuget

# Function to detect project structure
detect_project_structure() {
    if [ -d "csharp" ] && [ -d "csharp/Platform.$REPOSITORY_NAME" ]; then
        echo "multi"
    elif [ -f "Platform.$REPOSITORY_NAME.csproj" ]; then
        echo "single"
    else
        echo "unknown"
    fi
}

# Settings
TARGET_BRANCH="gh-pages"
SHA=$(git rev-parse --verify HEAD)
COMMIT_USER_NAME="linksplatform"
COMMIT_USER_EMAIL="linksplatformtechnologies@gmail.com"
REPOSITORY="github.com/linksplatform/$REPOSITORY_NAME"

# Insert repository name into DocFX's configuration files
sed -i "s/\$REPOSITORY_NAME/$REPOSITORY_NAME/g" toc.yml
sed -i "s/\$REPOSITORY_NAME/$REPOSITORY_NAME/g" docfx.json

# DocFX installation
PROJECT_TYPE=$(detect_project_structure)

if [ "$PROJECT_TYPE" = "multi" ]; then
    nuget install docfx.console -Version 2.51
else
    nuget install docfx.console
fi

mono $(echo ./*docfx.console.*)/tools/docfx.exe docfx.json

# Clone the existing gh-pages for this repo into out/
# Create a new empty branch if gh-pages doesn't exist yet (should only happen on first deploy)
git clone "https://$REPOSITORY" out
cd out || exit
git checkout $TARGET_BRANCH || git checkout --orphan $TARGET_BRANCH
cd ..

# Handle different project structures
if [ "$PROJECT_TYPE" = "multi" ]; then
    mkdir -p out/csharp
    # Clean out existing contents
    rm -rf out/csharp/**/* || exit 0
    # Copy generated docs site
    cp -r _site/* out/csharp/
    cd out/csharp || exit
else
    # Clean out existing contents
    rm -rf out/**/* || exit 0
    # Copy generated docs site
    cp -r _site/* out
    cd out || exit
fi

# Do not use index.md
cp README.html index.html

# Enter repository's folder (for multi-project, we're already in csharp subfolder)
if [ "$PROJECT_TYPE" = "multi" ]; then
    cd ..
fi

# Now let's go have some fun with the cloned repo
git config user.name "$COMMIT_USER_NAME"
git config user.email "$COMMIT_USER_EMAIL"
git remote rm origin
git remote add origin "https://linksplatform:$GITHUB_TOKEN@$REPOSITORY.git"

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add --all
git commit -m "Deploy to GitHub Pages: $SHA"

# Now that we're all set up, we can push.
git push "https://linksplatform:$GITHUB_TOKEN@$REPOSITORY.git" "$TARGET_BRANCH"
cd ..

# Clean up
rm -rf out
rm -rf _site
rm -rf docfx.console*