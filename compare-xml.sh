#!/bin/bash

# Check if two files are provided as arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <file1.xml> <file2.xml>"
    exit 1
fi

FILE1="$1"
FILE2="$2"
DIFF_FILE="differences.txt"

# Temporary files to store individual XML documents
TEMP1=$(mktemp)
TEMP2=$(mktemp)

# Function to normalize XML (remove extra spaces, newlines, etc.)
normalize_xml() {
    xmllint --format - | sed 's/>\s*</></g' | tr -d '\n'
}

# Function to compare two files line by line and write differences with markers
compare_files() {
    local file1="$1"
    local file2="$2"
    local diff_file="$3"

    echo "Comparing $file1 and $file2..." >> "$diff_file"
    diff --unchanged-line-format='%L' --old-line-format='<<< %L' --new-line-format='>>> %L' "$file1" "$file2" >> "$diff_file"
    echo "----------------------------------------" >> "$diff_file"
}

# Split the files into individual XML documents and compare
split_and_compare() {
    local file="$1"
    local temp_file="$2"
    csplit -s -f "${temp_file}_part_" "$file" '/<?xml/' '{*}'
}

# Split the XML files into individual documents
split_and_compare "$FILE1" "$TEMP1"
split_and_compare "$FILE2" "$TEMP2"

# Clear the differences file
> "$DIFF_FILE"

# Compare the corresponding parts
for part1 in "${TEMP1}_part_"*; do
    part2="${TEMP2}_part_$(basename "$part1" | sed 's/.*_//')"
    if [ -f "$part2" ]; then
        if diff <(cat "$part1" | normalize_xml) <(cat "$part2" | normalize_xml) > /dev/null; then
            echo "Documents $(basename "$part1") are identical." >> "$DIFF_FILE"
        else
            echo "Documents $(basename "$part1") differ." >> "$DIFF_FILE"
            compare_files "$part1" "$part2" "$DIFF_FILE"
        fi
    else
        echo "Document $(basename "$part1") has no corresponding document