#!/bin/bash

# Input file containing multiple XML documents
input_file="multi_xml_file.xml"

# Temporary file to hold individual XML documents
temp_file=$(mktemp)

# Counter to keep track of XML documents
doc_count=0

# Use awk to split the file into individual XML documents
awk 'BEGIN { RS="</document>"; FS="\n" } {
    if ($0 ~ /<document>/) {
        doc_count++
        print $0 "</document>" > "'"$temp_file"'_" doc_count ".xml"
    }
}' "$input_file"

# Compare the XML documents
for file in "${temp_file}_"*.xml; do
    echo "Processing $file..."
    # Use xmllint to format and validate the XML
    xmllint --format "$file" --output "$file"
    
    # Example: Compare the current XML document with the first one
    if [ "$file" != "${temp_file}_1.xml" ]; then
        echo "Comparing ${temp_file}_1.xml with $file..."
        diff "${temp_file}_1.xml" "$file"
    fi
done

# Clean up temporary files
rm "${temp_file}_"*.xml