#!/bin/bash

# Hard-coded file names
file1="file1.txt"
file2="file2.txt"

# Check if the files exist
if [ ! -f "$file1" ]; then
  echo "Error: File '$file1' not found!"
  exit 1
fi

if [ ! -f "$file2" ]; then
  echo "Error: File '$file2' not found!"
  exit 1
fi

# Use the diff command to compare the files
echo "Comparing files '$file1' and '$file2':"
diff_output=$(diff "$file1" "$file2")

# Check if there are differences
if [ -z "$diff_output" ]; then
  echo "The files are identical."
else
  echo "$diff_output"
fi