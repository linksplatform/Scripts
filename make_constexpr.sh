#!/bin/bash

# Simple script to make $break, $continue, $any variables constexpr
# This script processes C++ header and source files

set -e

echo "Making \$break, \$continue, and 'any' variables constexpr..."
echo

# Function to process a single file
process_file() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    echo "Processing: $file"
    
    # Apply all transformations with sed
    sed -e 's/^\([ \t]*\)auto \$break = Constants\.Break;/\1static constexpr auto $break = Constants.Break;/g' \
        -e 's/^\([ \t]*\)auto \$break {Constants\.Break};/\1static constexpr auto $break {Constants.Break};/g' \
        -e 's/^\([ \t]*\)auto \$continue = Constants\.Continue;/\1static constexpr auto $continue = Constants.Continue;/g' \
        -e 's/^\([ \t]*\)auto \$continue {Constants\.Continue};/\1static constexpr auto $continue {Constants.Continue};/g' \
        -e 's/^\([ \t]*\)auto any = Constants\.Any;/\1static constexpr auto any = Constants.Any;/g' \
        -e 's/^\([ \t]*\)auto any {Constants\.Any};/\1static constexpr auto any {Constants.Any};/g' \
        "$file" > "$temp_file"
    
    # Check if changes were made
    if ! cmp -s "$file" "$temp_file"; then
        mv "$temp_file" "$file"
        echo "  ✓ Updated"
        return 0
    else
        rm "$temp_file"
        echo "  - No changes needed"
        return 1
    fi
}

# Main processing
target_dir="${1:-.}"

if [ ! -d "$target_dir" ]; then
    echo "Error: Directory does not exist: $target_dir"
    exit 1
fi

echo "Searching in directory: $target_dir"
echo

total_files=0
changed_files=0

# Process all C++ files
for file in $(find "$target_dir" -type f \( -name "*.h" -o -name "*.hpp" -o -name "*.cpp" -o -name "*.cc" \)); do
    total_files=$((total_files + 1))
    if process_file "$file"; then
        changed_files=$((changed_files + 1))
    fi
done

echo
echo "Summary: $changed_files out of $total_files files were modified"

if [ $changed_files -gt 0 ]; then
    echo "✓ Conversion completed successfully!"
else
    echo "- No files needed changes"
fi