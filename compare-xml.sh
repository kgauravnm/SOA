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
             <(echo "$doc2" | filter_known_differences) >> "$DIFF_FILE"
        echo "----------------------------------------" >> "$DIFF_FILE"
    fi
}

# Function to read XML documents one by one
read_xml_documents() {
    local file="$1"
    awk '
        BEGIN { doc = ""; in_doc = 0; depth = 0 }
        /<?xml/ {
            if (in_doc) {
                print doc
                doc = ""
                depth = 0
            }
            in_doc = 1
        }
        in_doc {
            doc = doc $0 "\n"
            if (/<[^/]/) depth++
            if (/<\/[^>]+>/) depth--
            if (depth == 0 && in_doc) {
                print doc
                doc = ""
                in_doc = 0
            }
        }
    ' "$file"
}

# Clear the differences file
> "$DIFF_FILE"

# Open file descriptors for reading
exec 3< <(read_xml_documents "$FILE1")
exec 4< <(read_xml_documents "$FILE2")

# Compare documents one by one
index=0
while true; do
    # Read documents from both files
    if ! read -r -u 3 doc1; then
        doc1=""
    fi
    if ! read -r -u 4 doc2; then
        doc2=""
    fi

    # Break if both files are exhausted
    if [ -z "$doc1" ] && [ -z "$doc2" ]; then
        break
    fi

    # Compare documents
    if [ -n "$doc1" ] && [ -n "$doc2" ]; then
        compare_xml_documents "$doc1" "$doc2" "$index"
    elif [ -n "$doc1" ]; then
        echo "Document $index has no corresponding document in the second file." >> "$DIFF_FILE"
    elif [ -n "$doc2" ]; then
        echo "Document $index has no corresponding document in the first file." >> "$DIFF_FILE"
    fi

    index=$((index + 1))
done

# Close file descriptors
exec 3<&-
exec 4<&-

echo "Differences written to $DIFF_FILE"