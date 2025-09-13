#!/bin/bash
# Test the old (problematic) version of the script

cp test.csproj test_old_result.csproj
echo "=== Testing old script behavior ==="
echo "Before (problematic version):"
cat test_old_result.csproj

# Apply the old problematic sed command
sed -i -e 's/netcoreapp3\.0/netcoreapp3.1/g' test_old_result.csproj

echo ""
echo "After (shows the problem - CSharpToCppTranslator path gets changed):"
cat test_old_result.csproj