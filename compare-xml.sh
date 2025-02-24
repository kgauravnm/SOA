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

# Function to process XML files in a streaming manner
process_xml_file() {
    local file="$1"
    awk '
        BEGIN { doc = ""; count = 0 }
        /<?xml/ {
            if (doc != "") {
                print doc > "temp_doc_" count
                close("temp_doc_" count)
                count++
            }
            doc = $0
        }
        !/<?xml/ { doc = doc "\n" $0 }
        END {
            if (doc != "") {
                print doc > "temp_doc_" count
                close("temp_doc_" count)
            }
        }
    ' "$file"
}

# Clear the differences file
> "$DIFF_FILE"

# Process the first file and store documents in memory
declare -A file1_docs
index=0
while IFS= read -r -d '' doc; do
    file1_docs["$index"]="$doc"
    index=$((index + 1))
done < <(process_xml_file "$FILE1" | tr '\n' '\0')

# Process the second file and compare documents
index=0
while IFS= read -r -d '' doc; do
    if [ -n "${file1_docs[$index]}" ]; then
        compare_xml_documents "${file1_docs[$index]}" "$doc" "$index"
    else
        echo "Document $index has no corresponding document in the first file." >> "$DIFF_FILE"
    fi
    index=$((index + 1))
done < <(process_xml_file "$FILE2" | tr '\n' '\0')

# Clean up temporary files
rm -f temp_doc_*

echo "Differences written to $DIFF_FILE"