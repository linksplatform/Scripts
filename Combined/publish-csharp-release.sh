#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Function to detect project structure
detect_project_structure() {
    if [ -f "CSHARP_PACKAGE_VERSION.txt" ] && [ -f "CSHARP_PACKAGE_RELEASE_NOTES.txt" ]; then
        echo "multi"
    elif [ -f "Platform.$REPOSITORY_NAME.csproj" ]; then
        echo "single"
    elif [ -d "csharp" ] && [ -f "csharp/Platform.$REPOSITORY_NAME/Platform.$REPOSITORY_NAME.csproj" ]; then
        echo "multi"
    else
        echo "unknown"
    fi
}

# Function to get package info for multi-project structure
get_multi_project_info() {
    if [ -f "CSHARP_PACKAGE_VERSION.txt" ]; then
        PACKAGE_VERSION=$(<CSHARP_PACKAGE_VERSION.txt)
    else
        echo "CSHARP_PACKAGE_VERSION.txt not found in multi-project repository."
        exit 1
    fi
    
    if [ -f "CSHARP_PACKAGE_RELEASE_NOTES.txt" ]; then
        PACKAGE_RELEASE_NOTES=$(<CSHARP_PACKAGE_RELEASE_NOTES.txt)
    else
        PACKAGE_RELEASE_NOTES="Release $PACKAGE_VERSION"
    fi
    
    PACKAGE_URL="https://www.nuget.org/packages/Platform.$REPOSITORY_NAME/$PACKAGE_VERSION"
    TAG="csharp_$PACKAGE_VERSION"
    RELEASE_NAME="[C#] $PACKAGE_VERSION"
}

# Function to get package info for single-project structure  
get_single_project_info() {
    sudo apt-get install -y xmlstarlet
    
    PACKAGE_VERSION=$(xmlstarlet sel -t -m '//VersionPrefix[1]' -v . -n <"Platform.$REPOSITORY_NAME.csproj")
    PACKAGE_RELEASE_NOTES=$(xmlstarlet sel -t -m '//PackageReleaseNotes[1]' -v . -n <"Platform.$REPOSITORY_NAME.csproj")
    
    if [ -z "$PACKAGE_VERSION" ]; then
        echo "Could not extract VersionPrefix from Platform.$REPOSITORY_NAME.csproj"
        exit 1
    fi
    
    PACKAGE_URL="https://www.nuget.org/packages/Platform.$REPOSITORY_NAME/$PACKAGE_VERSION"
    TAG="$PACKAGE_VERSION"
    RELEASE_NAME="$PACKAGE_VERSION"
}

# Function to check if release already exists
check_existing_release() {
    local tag=$1
    TAG_ID=$(curl --request GET --url "https://api.github.com/repos/${GITHUB_REPOSITORY}/releases/tags/${tag}" --header "authorization: Bearer ${GITHUB_TOKEN}" | jq -r '.id')
    
    if [ "$TAG_ID" != "null" ]; then
        echo "Release with tag $tag already published."
        exit 0
    fi
}

# Function to create release
create_release() {
    local tag=$1
    local name=$2
    local body=$3
    
    echo "Repository name: $GITHUB_REPOSITORY";
    echo "Tag: $tag";
    echo "Default branch: $DEFAULT_BRANCH";
    echo "Release name: $name";
    echo "Release body: $body";
    
    gh release create "${tag}" -t "${name}" -n "${body}"
}

# Main execution
PROJECT_TYPE=$(detect_project_structure)

echo "Detected project structure: $PROJECT_TYPE"

case $PROJECT_TYPE in
    "multi")
        get_multi_project_info
        ;;
    "single")
        get_single_project_info
        ;;
    "unknown")
        echo "Could not detect project structure. Expected either:"
        echo "  Multi-project: CSHARP_PACKAGE_VERSION.txt and CSHARP_PACKAGE_RELEASE_NOTES.txt"
        echo "  Single-project: Platform.\$REPOSITORY_NAME.csproj"
        exit 1
        ;;
esac

# Create release body with separator
SEPARATOR="

"
RELEASE_BODY="$PACKAGE_URL$SEPARATOR$PACKAGE_RELEASE_NOTES"

# Check if release already exists
check_existing_release "$TAG"

# Create the release
create_release "$TAG" "$RELEASE_NAME" "$RELEASE_BODY"