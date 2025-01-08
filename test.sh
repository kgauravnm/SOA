#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <file1> <file2> <output_file>"
    exit 1
fi

# Input files and output file
file1=$1
file2=$2
output_file=$3

# Check if the input files exist
if [ ! -f "$file1" ]; then
    echo "Error: File '$file1' not found!"
    exit 1
fi

if [ ! -f "$file2" ]; then
    echo "Error: File '$file2' not found!"
    exit 1
fi

# Compare files and write differences to the output file
diff "$file1" "$file2" > "$output_file"

# Check if differences were found
if [ -s "$output_file" ]; then
    echo "Differences written to '$output_file'."
else
    echo "No differences found."
    # Optionally, remove the empty output file
    rm "$output_file"
fi