#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

RUST_PACKAGE_PROJECT_PATH="rust/Cargo.toml"
echo "$RUST_PACKAGE_PROJECT_PATH"
echo "$RUST_PACKAGE_PROJECT_PATH" > RUST_PACKAGE_PROJECT_PATH.txt
RUST_PACKAGE_NAME=$(cat "$RUST_PACKAGE_PROJECT_PATH" | grep -Po "name = \"\K[^\"]+" | head -1)
echo "$RUST_PACKAGE_NAME"
echo "$RUST_PACKAGE_NAME" > RUST_PACKAGE_NAME.txt
RUST_PACKAGE_VERSION=$(cat "$RUST_PACKAGE_PROJECT_PATH" | grep "^version = " | grep -Eo "([0-9]|\.)+")
echo "$RUST_PACKAGE_VERSION"
echo "$RUST_PACKAGE_VERSION" > RUST_PACKAGE_VERSION.txt