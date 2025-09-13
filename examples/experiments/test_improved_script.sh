#!/bin/bash
# Test the improved fixed script

cp full_test.csproj improved_test_result.csproj
echo "=== Testing improved fixed script ==="
echo "Before:"
cat improved_test_result.csproj

# Apply the improved script commands
# Step 1: Use netcoreapp3.1 instead of netcoreapp3.0 (improved version)
sed -i -e 's/<TargetFramework>netcoreapp3\.0<\/TargetFramework>/<TargetFramework>netcoreapp3.1<\/TargetFramework>/g' -e 's/netcoreapp3\.0\([;<]\)/netcoreapp3.1\1/g' -e 's/netcoreapp3\.0<\/TargetFrameworks/netcoreapp3.1<\/TargetFrameworks/g' improved_test_result.csproj

# Step 2: Add net5 target framework 
sed -i -e 's|netstandard2\.1<\/TargetFrameworks|netstandard2.1;net5<\/TargetFrameworks|g' -e 's|netcoreapp3\.1<\/TargetFrameworks|netcoreapp3.1;net5<\/TargetFrameworks|g' improved_test_result.csproj

# Step 3: Replace application's target framework
sed -i -e 's|<TargetFramework>netcoreapp3\.1<\/TargetFramework>|<TargetFramework>net5<\/TargetFramework>|g' improved_test_result.csproj

echo ""
echo "After (should properly transform TargetFrameworks and preserve CSharpToCppTranslator path):"
cat improved_test_result.csproj