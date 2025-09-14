#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Function to detect project structure
detect_project_structure() {
    if [ -f "CSHARP_PACKAGE_VERSION.txt" ]; then
        echo "multi"
    elif [ -f "Platform.$REPOSITORY_NAME.csproj" ]; then
        echo "single"
    elif [ -d "csharp" ] && [ -f "csharp/Platform.$REPOSITORY_NAME/Platform.$REPOSITORY_NAME.csproj" ]; then
        echo "multi"
    else
        echo "unknown"
    fi
}

# Function to get version for multi-project structure
get_multi_project_version() {
    PACKAGE_VERSION=$(<CSHARP_PACKAGE_VERSION.txt)
    echo "Using version from CSHARP_PACKAGE_VERSION.txt: $PACKAGE_VERSION"
}

# Function to get version for single-project structure
get_single_project_version() {
    # Pack first to generate the package file
    dotnet pack -c Release
    
    # Extract version from generated package file
    PackageFileNamePrefix="bin/Release/Platform.$REPOSITORY_NAME."
    PackageFileNameSuffix=".nupkg"
    PackageFileName=$(echo "$PackageFileNamePrefix"*"$PackageFileNameSuffix")
    PACKAGE_VERSION="${PackageFileName#$PackageFileNamePrefix}"
    PACKAGE_VERSION="${PackageFileNameSuffix%$PackageFileNameSuffix}"
    echo "Extracted version from package file: $PACKAGE_VERSION"
}

# Function to check if NuGet package already exists
check_nuget_exists() {
    local version=$1
    NuGetPackageUrl="https://globalcdn.nuget.org/packages/Platform.$REPOSITORY_NAME.$version.nupkg"
    NuGetPackageUrl=$(echo "$NuGetPackageUrl" | tr '[:upper:]' '[:lower:]')
    
    NuGetPageStatus="$(curl -Is "$NuGetPackageUrl" | head -1)"
    StatusContents=( $NuGetPageStatus )
    if [ "${StatusContents[1]}" == "200" ]; then
        echo "NuGet with current version is already pushed."
        exit 0
    fi
    
    echo "The NuGet package does not exist at $NuGetPackageUrl"
}

# Function to pack and push NuGet package
pack_and_push() {
    # Pack NuGet package (if not already packed for single-project)
    if [ "$PROJECT_TYPE" = "multi" ]; then
        dotnet pack -c Release
    fi
    
    # Push NuGet package
    if [ "$PROJECT_TYPE" = "single" ]; then
        dotnet nuget push ./**/*.nupkg -s https://api.nuget.org/v3/index.json -k "${NUGETTOKEN}"
    else
        dotnet nuget push ./**/*.nupkg -s https://api.nuget.org/v3/index.json --skip-duplicate -k "${NUGETTOKEN}"
    fi
}

# Function to cleanup
cleanup() {
    find . -type f -name '*.nupkg' -delete
    find . -type f -name '*.snupkg' -delete
}

# Main execution
PROJECT_TYPE=$(detect_project_structure)

echo "Detected project structure: $PROJECT_TYPE"

case $PROJECT_TYPE in
    "multi")
        get_multi_project_version
        ;;
    "single")
        get_single_project_version
        ;;
    "unknown")
        echo "Could not detect project structure. Expected either:"
        echo "  Multi-project: CSHARP_PACKAGE_VERSION.txt"
        echo "  Single-project: Platform.\$REPOSITORY_NAME.csproj"
        exit 1
        ;;
esac

# Check if package already exists
check_nuget_exists "$PACKAGE_VERSION"

# Pack and push
pack_and_push

# Clean up
cleanup