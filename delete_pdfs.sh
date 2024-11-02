#!/bin/bash

# Directories to search for PDF files
directories=("AI" "Programming" "Database" "Security" "Math" "Others")

# Loop through each directory and delete PDF files
for dir in "${directories[@]}"; do
    find "$dir" -type f -name "*.pdf" -exec rm -f {} \;
done

echo "All PDF files have been deleted from the specified directories."
