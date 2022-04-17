#!/bin/bash
set -e # Exit with nonzero exit code if anything failss

SEPARATOR="

"

if [ ! -f "RUST_PACKAGE_VERSION.txt" ]
then
    echo "RUST_PACKAGE_VERSION.txt not found."
    exit 1
fi

PACKAGE_VERSION=$(<RUST_PACKAGE_VERSION.txt)
PACKAGE_RELEASE_NOTES=$(<RUST_PACKAGE_RELEASE_NOTES.txt)
PACKAGE_URL="https://crates.io/crates/doublets/$PACKAGE_VERSION"

TAG="rust_$PACKAGE_VERSION"
RELEASE_NAME="[Rust] $PACKAGE_VERSION"
RELEASE_BODY="$PACKAGE_URL$SEPARATOR$PACKAGE_RELEASE_NOTES"

publish-release.sh $TAG $RELEASE_NAME $RELEASE_BODY
