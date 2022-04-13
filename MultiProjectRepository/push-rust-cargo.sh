#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

RUST_PACKAGE_NAME=$(<RUST_PACKAGE_NAME.txt)
RUST_PACKAGE_VERSION=$(head -n 1 RUST_PACKAGE_VERSION.txt)

> RUST_PACKAGE_NAME.txt
> RUST_PACKAGE_VERSION.txt

# Ensure Cargo package does not exist
CargoPackageUrl="https://crates.io/api/v1/crates/$RUST_PACKAGE_NAME/$RUST_PACKAGE_VERSION/download"
CargoPageStatus="$(curl -ILs "$CargoPackageUrl")"
# echo "$CargoPageStatus"
if echo "$CargoPageStatus" | grep -q "HTTP/2 200"; then
    echo "Cargo with current version is already pushed."
    exit 0
fi

if [ -z "$1" ]
  then
    cargo publish
  else
    cd $1
    cargo publish
fi
