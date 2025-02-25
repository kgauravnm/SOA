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

# Function to normalize XML (removes extra spaces, newlines, etc.)
normalize_xml() {
    xmllint --format - 2>/dev/null | sed 's/>\s*</></g' | tr -d '\n'
}

# Function to filter out known differences
filter_known_differences() {
    if [ -s "$IGNORE_PATTERNS_FILE" ]; then
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

    normalized_doc1=$(echo "$doc1" | normalize_xml)
    normalized_doc2=$(echo "$doc2" | normalize_xml)

    if ! diff <(echo "$normalized_doc1") <(echo "$normalized_doc2") > /dev/null; then
        echo "Document $index differs:" >> "$DIFF_FILE"
        diff -u <(echo "$normalized_doc1" | filter_known_differences) \
               <(echo "$normalized_doc2" | filter_known_differences) >> "$DIFF_FILE"
        echo "----------------------------------------" >> "$DIFF_FILE"
    fi
}

# Function to extract and split XML documents
read_xml_documents() {
    local file="$1"
    awk '
        BEGIN { doc = ""; in_doc = 0 }
        /<?xml/ { 
            if (in_doc) { 
                print doc
                doc = ""
            }
            in_doc = 1
        }
        in_doc { 
            doc = doc $0 "\n"
        }
        END { if (in_doc) print doc }
    ' "$file"
}

# Clear the differences file
> "$DIFF_FILE"

# Read XML documents into arrays
mapfile -t docs1 < <(read_xml_documents "$FILE1")
mapfile -t docs2 < <(read_xml_documents "$FILE2")

# Compare documents one by one
index=0
while [ "$index" -lt "${#docs1[@]}" ] || [ "$index" -lt "${#docs2[@]}" ]; do
    doc1="${docs1[index]:-}"
    doc2="${docs2[index]:-}"

    if [ -n "$doc1" ] && [ -n "$doc2" ]; then
        compare_xml_documents "$doc1" "$doc2" "$index"
    elif [ -n "$doc1" ]; then
        echo "Document $index exists only in $FILE1." >> "$DIFF_FILE"
    elif [ -n "$doc2" ]; then
        echo "Document $index exists only in $FILE2." >> "$DIFF_FILE"
    fi

    index=$((index + 1))
done

echo "Differences written to $DIFF_FILE"