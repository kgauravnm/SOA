#!/bin/bash

# Input files containing multiple XML documents
file1="file1.xml"
file2="file2.xml"

# Temporary directory to hold individual XML documents
temp_dir=$(mktemp -d)

# Function to split a file into individual XML documents
split_xml_file() {
    local input_file=$1
    local output_prefix=$2

    # Use awk to split the file into individual XML documents
    awk 'BEGIN { RS="</document>"; FS="\n" } {
        if ($0 ~ /<document>/) {
            doc_count++
            print $0 "</document>" > "'"$temp_dir"'/'$output_prefix'_" doc_count ".xml"
        }
    }' "$input_file"
}

# Split the first file into individual XML documents
split_xml_file "$file1" "file1"

# Split the second file into individual XML documents
split_xml_file "$file2" "file2"

# Compare the XML documents
for file1_xml in "$temp_dir"/file1_*.xml; do
    # Extract the document number from the filename
    doc_number=$(basename "$file1_xml" | sed 's/file1_\(.*\).xml/\1/')
    file2_xml="$temp_dir/file2_$doc_number.xml"

    # Check if the corresponding XML document exists in the second file
    if [ -f "$file2_xml" ]; then
        echo "Comparing document $doc_number..."
        diff "$file1_xml" "$file2_xml"
    else
        echo "Document $doc_number not found in $file2."
    fi
done

# Clean up temporary files
rm -r "$temp_dir"