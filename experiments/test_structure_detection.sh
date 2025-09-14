#!/bin/bash

# Create test directory structure
mkdir -p experiments/test_multi/csharp/Platform.TestRepo
mkdir -p experiments/test_single

# Test multi-project detection
cd experiments/test_multi
echo "1.0.0" > CSHARP_PACKAGE_VERSION.txt
echo "Test release notes" > CSHARP_PACKAGE_RELEASE_NOTES.txt
mkdir -p csharp/Platform.TestRepo
touch csharp/Platform.TestRepo/Platform.TestRepo.csproj

# Extract detection function and test it
source ../../Combined/publish-csharp-release.sh
detect_result=$(detect_project_structure)
echo "Multi-project detection result: $detect_result"

cd ../test_single
touch Platform.TestRepo.csproj

# Test single-project detection
detect_result=$(detect_project_structure)
echo "Single-project detection result: $detect_result"

cd ../..

# Clean up
rm -rf experiments/test_multi experiments/test_single