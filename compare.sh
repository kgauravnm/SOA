#!/bin/bash

# Hard-coded file names
file1="file1.txt"
file2="file2.txt"
output_file="differences.txt"

# Check if the files exist
if [ ! -f "$file1" ]; then
  echo "Error: File '$file1' not found!"
  exit 1
fi

if [ ! -f "$file2" ]; then
  echo "Error: File '$file2' not found!"
  exit 1
fi

# Use the diff command to compare the files and write output to a file
diff "$file1" "$file2" > "$output_file"

# Check if the differences file is empty
if [ -s "$output_file" ]; then
  echo "Differences between '$file1' and '$file2' have been written to '$output_file'."
else
  echo "The files are identical. No differences found."
  rm "$output_file" # Remove the empty file
fi