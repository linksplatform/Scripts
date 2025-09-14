#!/bin/bash

# Function to detect project structure (extracted from our combined script)
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

# Set test repository name
export REPOSITORY_NAME="TestRepo"

# Test 1: Multi-project with version files
echo "=== Test 1: Multi-project with version files ==="
mkdir -p test1
cd test1
echo "1.0.0" > CSHARP_PACKAGE_VERSION.txt
echo "Test release" > CSHARP_PACKAGE_RELEASE_NOTES.txt
result=$(detect_project_structure)
echo "Result: $result (expected: multi)"
cd ..

# Test 2: Single-project
echo "=== Test 2: Single-project ==="
mkdir -p test2  
cd test2
touch Platform.TestRepo.csproj
result=$(detect_project_structure)
echo "Result: $result (expected: single)"
cd ..

# Test 3: Multi-project with csharp directory
echo "=== Test 3: Multi-project with csharp directory ==="
mkdir -p test3/csharp/Platform.TestRepo
cd test3
touch csharp/Platform.TestRepo/Platform.TestRepo.csproj
result=$(detect_project_structure)
echo "Result: $result (expected: multi)"
cd ..

# Test 4: Unknown structure
echo "=== Test 4: Unknown structure ==="
mkdir -p test4
cd test4
result=$(detect_project_structure)
echo "Result: $result (expected: unknown)"
cd ..

# Clean up
rm -rf test1 test2 test3 test4

echo "=== All tests completed ==="