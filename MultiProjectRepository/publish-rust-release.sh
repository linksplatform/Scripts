#!/bin/bash
set -e # Exit with nonzero exit code if anything failss

SEPARATOR="

"

if [ ! -f "RUST_PACKAGE_VERSION.txt" ]
then
    echo "RUST_PACKAGE_VERSION.txt not found."
    exit 1
fi

PACKAGE_NAME=$(<RUST_PACKAGE_NAME.txt)
PACKAGE_VERSION=$(<RUST_PACKAGE_VERSION.txt)
PACKAGE_URL="https://crates.io/crates/$PACKAGE_NAME/$PACKAGE_VERSION"

TAG="rust_$PACKAGE_VERSION"
RELEASE_NAME="[Rust] $PACKAGE_VERSION"
RELEASE_BODY="$PACKAGE_URL"

publish-release.sh $TAG $RELEASE_NAME $RELEASE_BODY
