#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

RUST_PACKAGE_NAME=$(<RUST_PACKAGE_NAME.txt)
RUST_PACKAGE_VERSION=$(<RUST_PACKAGE_VERSION.txt)

# Ensure Cargo package does not exist
CargoPackageUrl="https://crates.io/api/v1/crates/$RUST_PACKAGE_NAME/$RUST_PACKAGE_VERSION/download"
CargoPageStatus="$(curl -ILs "$CargoPackageUrl")"
# echo "$CargoPageStatus"
if echo "$CargoPageStatus" | grep -q "HTTP/2 200"; then 
    echo "Cargo with current version is already pushed."
    exit 0
fi

echo "The cargo package does not exist at $CargoPackageUrl"

# Pack Cargo package
# dotnet pack -c Release

# Push Cargo package
# dotnet nuget push ./**/*.nupkg -s https://api.Cargo.org/v3/index.json --skip-duplicate -k "${CargoTOKEN}"

# Clean up
# find . -type f -name '*.nupkg' -delete
# find . -type f -name '*.snupkg' -delete
