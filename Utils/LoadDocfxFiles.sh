#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Load docfx configuration files from the Files repository
# Usage: ./LoadDocfxFiles.sh [target_directory]

TARGET_DIR="${1:-.}"
FILES_REPO_BASE="https://raw.githubusercontent.com/linksplatform/Files/main/docfx"

echo "Loading docfx files to $TARGET_DIR..."

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Download docfx configuration files
curl -s "$FILES_REPO_BASE/docfx.json" -o "$TARGET_DIR/docfx.json"
curl -s "$FILES_REPO_BASE/toc.yml" -o "$TARGET_DIR/toc.yml"
curl -s "$FILES_REPO_BASE/filter.yml" -o "$TARGET_DIR/filter.yml"

echo "Docfx files loaded successfully:"
echo "  - docfx.json"
echo "  - toc.yml"
echo "  - filter.yml"