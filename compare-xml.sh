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
    xmllint --format - 2>/dev/null | sed 's/>\s*</></g' | tr -d '\n'
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

# Normalize entire XML files first (avoids repeated processing)
echo "Normalizing XML files..."
xmllint --format "$FILE1" 2>/dev/null | sed 's/>\s*</></g' | tr -d '\n' > "${FILE1}.norm"
xmllint --format "$FILE2" 2>/dev/null | sed 's/>\s*</></g' | tr -d '\n' > "${FILE2}.norm"

# Compare normalized files
echo "Comparing files..."
diff -u <(filter_known_differences < "${FILE1}.norm") \
       <(filter_known_differences < "${FILE2}.norm") > "$DIFF_FILE"

echo "Comparison completed. Differences saved to $DIFF_FILE."

# Cleanup temporary files
rm -f "${FILE1}.norm" "${FILE2}.norm"