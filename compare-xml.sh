#!/bin/bash

# Input XML files
FILE1=$1
FILE2=$2
OUTPUT_FILE=$3

# Check if all arguments are provided
if [ -z "$FILE1" ] || [ -z "$FILE2" ] || [ -z "$OUTPUT_FILE" ]; then
    echo "Usage: $0 <file1.xml> <file2.xml> <output_diff_file>"
    exit 1
fi

# Temporary files for formatted XML
FORMATTED_FILE1=$(mktemp)
FORMATTED_FILE2=$(mktemp)

# Format the XML files using xmllint
xmllint --format "$FILE1" > "$FORMATTED_FILE1"
xmllint --format "$FILE2" > "$FORMATTED_FILE2"

# Compare the formatted XML files and write differences to the output file
echo "Comparing $FILE1 and $FILE2..."
{
    echo "Differences between $FILE1 and $FILE2:"
    echo "====================================="
    diff --label "$FILE1" --label "$FILE2" "$FORMATTED_FILE1" "$FORMATTED_FILE2" | while read -r line; do
        if [[ "$line" =~ ^[0-9]+c[0-9]+$ ]]; then
            echo "Change at line: $line"
        elif [[ "$line" =~ ^\< ]]; then
            echo "In $FILE1: $line"
        elif [[ "$line" =~ ^\> ]]; then
            echo "In $FILE2: $line"
        elif [[ "$line" =~ ^---$ ]]; then
            echo "----------------"
        fi
    done
} > "$OUTPUT_FILE"

# Check if there were differences
if [ $? -eq 0 ]; then
    echo "No differences found. The XML files are identical."
else
    echo "Differences found. See $OUTPUT_FILE for details."
fi

# Clean up temporary files
rm "$FORMATTED_FILE1" "$FORMATTED_FILE2"