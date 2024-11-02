#!/bin/bash

# generate_sample_pdfs.sh - Script to generate sample PDF files for testing

# Set the root folder where the sample PDFs will be created
ROOT_FOLDER="/home/mohd/test_root_folder"

# Create the root folder if it doesn't exist
mkdir -p "$ROOT_FOLDER"

# Define categories, subcategories, and sample content
declare -A samples=(
    ["Programming/Python"]="This document covers python programming, including scripting and py files."
    ["Programming/Java"]="Learn about java programming, JVM, and JDK in this document."
    ["Programming/C"]="C programming guide with pointers and memory allocation."
    ["AI/Machine_Learning"]="An introduction to machine learning, including supervised and unsupervised learning techniques in AI."
    ["AI/Neural_Networks"]="Deep learning with neural networks and backpropagation methods in AI."
    ["Math/Linear_Algebra"]="Study linear algebra concepts like matrices, vectors, and eigenvalues in math."
    ["Math/Calculus"]="Calculus basics covering derivatives, integrals, and limits in math."
    ["Database/SQL"]="SQL queries, relational databases, and joins explained in database context."
    ["Database/NoSQL"]="Introduction to NoSQL databases like MongoDB and Cassandra in database systems."
    ["Security/Cryptography"]="Cryptography concepts including encryption, decryption, and ciphers in security."
    ["Security/Network_Security"]="Network security principles, firewalls, and intrusion detection systems in security."
    ["Others"]="General knowledge document without specific keywords."
)

# Generate sample PDFs
for category_subcategory in "${!samples[@]}"; do
    # Replace slashes with underscores for filenames
    filename="${category_subcategory//\//_}"
    content="${samples[$category_subcategory]}"
    filepath="$ROOT_FOLDER/${filename}.txt"

    # Create a text file with sample content
    echo "$content" > "$filepath"

    # Convert the text file to PDF using LibreOffice
    libreoffice --headless --convert-to pdf "$filepath" --outdir "$ROOT_FOLDER"

    # Remove the text file
    rm "$filepath"

    echo "Generated PDF: $ROOT_FOLDER/${filename}.pdf"
done

# Generate additional random PDFs for the 'Others' category
for i in {1..3}; do
    filepath="$ROOT_FOLDER/Others_Document_$i.txt"
    echo "This is a general document without specific category keywords." > "$filepath"
    libreoffice --headless --convert-to pdf "$filepath" --outdir "$ROOT_FOLDER"
    rm "$filepath"
    echo "Generated PDF: $ROOT_FOLDER/Others_Document_$i.pdf"
done
