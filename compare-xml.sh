#!/bin/bash

# Check if two files are provided as arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <file1.xml> <file2.xml>"
    exit 1
fi

FILE1="$1"
FILE2="$2"
DIFF_FILE="differences.txt"
IGNORE_PATTERNS_FILE="ignore_patterns.txt"

# Function to normalize XML (remove extra spaces, newlines, etc.)
normalize_xml() {
    xmllint --format - | sed 's/>\s*</></g' | tr -d '\n'
}

# Function to filter out known differences
filter_known_differences() {
    if [ -f "$IGNORE_PATTERNS_FILE" ]; then
        grep -v -f "$IGNORE_PATTERNS_FILE"
    else
        cat
    fi
}

# Function to compare two XML documents
compare_xml_documents() {
    local doc1="$1"
    local doc2="$2"
    local index="$3"

    if ! diff <(echo "$doc1" | normalize_xml) <(echo "$doc2" | normalize_xml) > /dev/null; then
        echo "Document $index differs:" >> "$DIFF_FILE"
        diff --unchanged-group-format='' \
             --old-group-format='<<< Line %dn in Document %df: %<' \
             --new-group-format='>>> Line %dN in Document %df: %>' \
             <(echo "$doc1" | filter_known_differences) \
             <(echo "$doc2" | filter_known_differences) >> "$DI