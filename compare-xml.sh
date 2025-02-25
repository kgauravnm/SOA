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

# Function to extract individual XML documents
extract_xml_documents() {
    local file="$1"
    local output_dir="$2"

    mkdir -p "$output_dir"
    awk '
        BEGIN { doc = ""; in_doc = 0; depth = 0; file_count = 0 }
        /<\?xml/ {
            if (in_doc) {
                print doc > sprintf("%s/doc_%d.xml", "'$output_dir'", file_count)
                close(sprintf("%s/doc_%d.xml", "'$output_dir'", file_count))
                doc = ""
                depth = 0
                file_count++
            }
            in_doc = 1
        }
        in_doc {
            doc = doc $0 "\n"
            if (/<[^/]/) depth++
            if (/<\/[^>]+>/) depth--
            if (depth == 0 && in_doc) {
                print doc > sprintf("%s/doc_%d.xml", "'$output_dir'", file_count)
                close(sprintf("%s/doc_%d.xml", "'$output_dir'", file_count))
                doc = ""
                in_doc = 0
                file_count++
            }
        }
    ' "$file"
}

# Normalize XML safely
normalize_xml() {
    local file="$1"
    local output="$2"

    if ! xmllint --noout "$file" 2>/dev/null; then
        echo "Warning: Invalid XML detected in $file. Attempting auto-fix..."
        xmllint --recover --format "$file" > "$output" 2>/dev/null
    else
        xmllint --format "$file" > "$output" 2>/dev/null
    fi

    if [ ! -s "$output" ]; then
        echo "Error: Failed to normalize XML for $file. Skipping."
        exit 1
    fi
}

# Function to filter known differences
filter_known_differences() {
    if [ -s "$IGNORE_PATTERNS_FILE" ]; then
        grep -v -f "$IGNORE_PATTERNS_FILE"
    else
        cat
    fi
}

# Prepare directories
TMP_DIR1="xml_docs_1"
TMP_DIR2="xml_docs_2"
rm -rf "$TMP_DIR1" "$TMP_DIR2" && mkdir -p "$TMP_DIR1" "$TMP_DIR2"

# Extract XML documents
echo "Extracting XML documents from $FILE1..."
extract_xml_documents "$FILE1" "$TMP_DIR1"
echo "Extracting XML documents from $FILE2..."
extract_xml_documents "$FILE2" "$TMP_DIR2"

# Get document count
DOC_COUNT1=$(ls -1 "$TMP_DIR1" | wc -l)
DOC_COUNT2=$(ls -1 "$TMP_DIR2" | wc -l)

# Check if document counts match
if [ "$DOC_COUNT1" -ne "$DOC_COUNT2" ]; then
    echo "Warning: Different number of XML documents found ($DOC_COUNT1 vs $DOC_COUNT2)."
fi

# Clear the differences file
> "$DIFF_FILE"

# Compare XML documents one by one
index=0
while [ $index -lt "$DOC_COUNT1" ] || [ $index -lt "$DOC_COUNT2" ]; do
    FILE1_DOC="$TMP_DIR1/doc_$index.xml"
    FILE2_DOC="$TMP_DIR2/doc_$index.xml"

    if [ ! -f "$FILE1_DOC" ]; then
        echo "Document $index missing in first file." >> "$DIFF_FILE"
        index=$((index + 1))
        continue
    fi
    if [ ! -f "$FILE2_DOC" ]; then
        echo "Document $index missing in second file." >> "$DIFF_FILE"
        index=$((index + 1))
        continue
    fi

    # Normalize XML
    normalize_xml "$FILE1_DOC" "${FILE1_DOC}.norm"
    normalize_xml "$FILE2_DOC" "${FILE2_DOC}.norm"

    # Extract only the changed values instead of full XML tags
    diff_output=$(diff --unchanged-group-format='' \
                       --old-group-format='<<< %L' \
                       --new-group-format='>>> %L' \
                       <(cat "${FILE1_DOC}.norm" | filter_known_differences) \
                       <(cat "${FILE2_DOC}.norm" | filter_known_differences))

    if [ -n "$diff_output" ]; then
        echo "Differences in document $index:" >> "$DIFF_FILE"
        echo "$diff_output" >> "$DIFF_FILE"
        echo "----------------------------------------" >> "$DIFF_FILE"
    fi

    index=$((index + 1))
done

# Cleanup temporary files
rm -rf "$TMP_DIR1" "$TMP_DIR2"

# Display results
if [ ! -s "$DIFF_FILE" ]; then
    echo "No differences found."
else
    echo "Differences found. Saved to $DIFF_FILE."
fi