#!/bin/bash
# Test the complete fixed script

cp full_test.csproj full_test_result.csproj
echo "=== Testing complete fixed script ==="
echo "Before:"
cat full_test_result.csproj

# Apply all the fixed script commands
# Step 1: Use netcoreapp3.1 instead of netcoreapp3.0
sed -i -e 's/<TargetFramework>netcoreapp3\.0<\/TargetFramework>/<TargetFramework>netcoreapp3.1<\/TargetFramework>/g' -e 's/netcoreapp3\.0<\/TargetFrameworks/netcoreapp3.1<\/TargetFrameworks/g' full_test_result.csproj

# Step 2: Add net5 target framework 
sed -i -e 's|netstandard2\.1<\/TargetFrameworks|netstandard2.1;net5<\/TargetFrameworks|g' -e 's|netcoreapp3\.1<\/TargetFrameworks|netcoreapp3.1;net5<\/TargetFrameworks|g' full_test_result.csproj

# Step 3: Replace application's target framework
sed -i -e 's|<TargetFramework>netcoreapp3\.1<\/TargetFramework>|<TargetFramework>net5<\/TargetFramework>|g' full_test_result.csproj

echo ""
echo "After (should preserve CSharpToCppTranslator path):"
cat full_test_result.csproj