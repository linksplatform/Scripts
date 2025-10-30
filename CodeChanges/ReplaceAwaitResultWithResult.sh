#!/bin/bash

# Replace .AwaitResult() with .Result in all .cs files
# This handles cases with or without spaces around the dot operator
find . -type f -name "*.cs" -exec sed -i 's/\.\s*AwaitResult\s*()/.Result/g' {} \;
