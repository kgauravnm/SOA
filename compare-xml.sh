#!/bin/bash

# Check if two files are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <file1.xml> <file2.xml>"
    exit 1
fi

FILE1="$1"
FILE2="$2"
DIFF_FILE="differences.txt"
IGNORE_PATTERNS_FILE="ignore_patterns.txt"

# Function to normalize XML efficiently
normalize_xml() {
    xmllint --format "$1" 2>/dev/null | sed 's/>\s*</></g' | tr -d '\n'
}

# Function to filter known differences
filter_known_differences() {
    if [ -s "$IGNORE_PATTERNS_FILE" ]; then
        grep -v -f "$IGNORE_PATTERNS_FILE"
    else
        cat
    fi
}

# Clear the differences file
> "$DIFF_FILE"

echo "Normalizing XML files..."
normalize_xml "$FILE1" > "${FILE1}.norm"
normalize_xml "$FILE2" > "${FILE2}.norm"

# Check if normalization was successful
if [ ! -s "${FILE1}.norm" ] || [ ! -s "${FILE2}.norm" ]; then
    echo "Error: Failed to normalize XML files. Check if the input files are valid XML."
    exit 1
fi

echo "Comparing files..."
diff_output=$(diff -u <(filter_known_differences < "${FILE1}.norm") \
                   <(filter_known_differences < "${FILE2}.norm"))

# Check if any differences were found
if [ -z "$diff_output" ]; then
    echo "No differences found."
else
    echo "$diff_output" > "$DIFF_FILE"
    echo "Differences found. Saved to $DIFF_FILE."
fi

# Cleanup temporary files
rm -f "${FILE1}.norm" "${FILE2}.norm"