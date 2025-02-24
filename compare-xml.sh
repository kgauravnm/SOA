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

    if diff <(echo "$doc1" | normalize_xml) <(echo "$doc2" | normalize_xml) > /dev/null; then
        echo "Document $index is identical." >> "$DIFF_FILE"
    else
        echo "Document $index differs." >> "$DIFF_FILE"
        diff --unchanged-group-format='' \
             --old-group-format='<<< Line %dn in Document %df: %<' \
             --new-group-format='>>> Line %dN in Document %df: %>' \
             <(echo "$doc1" | filter_known_differences) \
             <(echo "$doc2" | filter_known_differences) >> "$DIFF_FILE"
        echo "----------------------------------------" >> "$DIFF_FILE"
    fi
}

# Function to split XML files into individual documents
split_xml_file() {
    local file="$1"
    awk '
        BEGIN { doc = ""; count = 0 }
        /<?xml/ {
            if (doc != "") {
                print doc
                doc = ""
            }
        }
        { doc = doc $0 "\n" }
        END {
            if (doc != "") {
                print doc
            }
        }
    ' "$file"
}

# Clear the differences file
> "$DIFF_FILE"

# Read documents from the first file into an array
mapfile -t file1_docs < <(split_xml_file "$FILE1")

# Read documents from the second file and compare
index=0
while IFS= read -r doc2; do
    if [ -n "${file1_docs[$index]}" ]; then
        compare_xml_documents "${file1_docs[$index]}" "$doc2" "$index"
    else
        echo "Document $index has no corresponding document in the first file." >> "$DIFF_FILE"
    fi
    index=$((index + 1))
done < <(split_xml_file "$FILE2")

# Handle case where file1 has more documents than file2
while [ "$index" -lt "${#file1_docs[@]}" ]; do
    echo "Document $index has no corresponding document in the second file." >> "$DIFF_FILE"
    index=$((index + 1))
done

echo "Differences written to $DIFF_FILE"