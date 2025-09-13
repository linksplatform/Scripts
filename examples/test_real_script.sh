#!/bin/bash
# Test the actual script by modifying it to just show URLs instead of cloning

echo "Testing the real script functionality..."

cd /tmp/gh-issue-solver-1757725240169

# Create a test version that doesn't clone
cp Utils/CloneAllOrganizationRepositoriesByHTTPS.sh examples/test_clone_script.sh

# Replace the clone function to just echo
sed -i 's/git clone --recurse-submodules -j8 ${clone_url};/echo "Would clone: ${clone_url}";/' examples/test_clone_script.sh

echo ""
echo "Running test script with linksplatform..."
./examples/test_clone_script.sh linksplatform | head -20