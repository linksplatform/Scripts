#!/bin/bash
# Test the new (fixed) version of the script

cp test.csproj test_new_result.csproj
echo "=== Testing new script behavior ==="
echo "Before:"
cat test_new_result.csproj

# Apply the new fixed sed commands
sed -i -e 's/<TargetFramework>netcoreapp3\.0<\/TargetFramework>/<TargetFramework>netcoreapp3.1<\/TargetFramework>/g' -e 's/netcoreapp3\.0<\/TargetFrameworks/netcoreapp3.1<\/TargetFrameworks/g' test_new_result.csproj

echo ""
echo "After (shows the fix - only TargetFramework tags changed, CSharpToCppTranslator path unchanged):"
cat test_new_result.csproj