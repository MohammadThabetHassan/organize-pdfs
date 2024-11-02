#!/usr/bin/env bash
# organize_pdfs.sh - Multi-Level PDF File Organizer Using Threading and Scripting

# Enable error handling
set -e
set -o pipefail

# Initialize variables
ROOT_FOLDER=""
REPORT=0

# Parse command-line arguments
print_usage() {
    echo "Usage: $0 --root /path/to/root_folder [--report]"
    echo "Options:"
    echo "  --root    Specify the root folder containing PDF files."
    echo "  --report  Generate an analysis report after organizing."
}

# Parse options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --root)
            ROOT_FOLDER="$2"
            shift 2
            ;;
        --report)
            REPORT=1
            shift
            ;;
        --help)
            print_usage
            exit 0
            ;;
        *)
            echo "Unknown parameter passed: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Check if root folder is provided
if [ -z "$ROOT_FOLDER" ]; then
    echo "Error: Root folder not specified."
    print_usage
    exit 1
fi

# Define categories and subcategories using associative arrays
declare -A categories
categories=(
    ["Programming"]="Python Java C"
    ["AI"]="Machine_Learning Neural_Networks"
    ["Math"]="Linear_Algebra Calculus"
    ["Database"]="SQL NoSQL"
    ["Security"]="Cryptography Network_Security"
    ["Others"]=""
)

# Create necessary directories
create_directories() {
    for category in "${!categories[@]}"; do
        mkdir -p "$ROOT_FOLDER/$category"
        subcats=${categories[$category]}
        for subcat in $subcats; do
            mkdir -p "$ROOT_FOLDER/$category/$subcat"
        done
    done
}

# Function to process files for a specific category
process_category() {
    local category="$1"
    local subcats="$2"

    echo "Processing category: $category"

    if [ -z "$subcats" ]; then
        # 'Others' category
        # Wait for other categories to finish
        wait "${pids[@]}"
        # Find remaining files in root folder and move them to Others
        find "$ROOT_FOLDER" -maxdepth 1 -type f -iname "*.pdf" -exec mv "{}" "$ROOT_FOLDER/Others/" \;
    else
        for subcat in $subcats; do
            subcat_pattern="${subcat//_/ }"
            # Find files matching subcategory
            shopt -s nocasematch
            find "$ROOT_FOLDER" -maxdepth 1 -type f -iname "*.pdf" | while read -r file; do
                if [ ! -f "$file" ]; then
                    continue
                fi
                filename=$(basename "$file")
                base_filename="${filename%.*}"
                base_filename="${base_filename//_/ }"
                base_filename=" $base_filename "
                if [[ "$base_filename" =~ [[:space:]]$subcat_pattern[[:space:]] ]]; then
                    mv "$file" "$ROOT_FOLDER/$category/$subcat/"
                    # Mark the file as correctly classified
                    echo "$file" >> "$ROOT_FOLDER/correctly_classified.txt"
                fi
            done
            shopt -u nocasematch
        done
    fi
}

# Main Execution
create_directories

# Get the total number of PDF files before processing
initial_total_files=$(find "$ROOT_FOLDER" -maxdepth 1 -type f -iname "*.pdf" | wc -l)
if [ "$initial_total_files" -eq 0 ]; then
    echo "No PDF files found in the root directory."
    exit 1
fi

# Clean up previous classification records
rm -f "$ROOT_FOLDER/correctly_classified.txt"

# Start processing each category in background processes, except 'Others'
pids=()
for category in "${!categories[@]}"; do
    if [ "$category" != "Others" ]; then
        subcats="${categories[$category]}"
        process_category "$category" "$subcats" &
        pids+=($!)
    fi
done

# Wait for all background processes to complete
for pid in "${pids[@]}"; do
    wait "$pid"
done

# Now process 'Others' category
process_category "Others" ""

# Function to generate analysis report
generate_report() {
    echo "Analysis Report:" > "$ROOT_FOLDER/analysis_report.txt"
    echo "----------------" >> "$ROOT_FOLDER/analysis_report.txt"
    total_files=0
    declare -A category_counts

    # Calculate total files and files per category
    for category in "${!categories[@]}"; do
        count=$(find "$ROOT_FOLDER/$category" -type f -iname "*.pdf" | wc -l)
        category_counts["$category"]=$count
        total_files=$((total_files + count))
    done

    # Calculate percentages and write to report
    for category in "${!categories[@]}"; do
        count=${category_counts[$category]}
        percentage=$(awk "BEGIN {printf \"%.2f\", ($count/$total_files)*100}")
        echo "$category: $percentage%" >> "$ROOT_FOLDER/analysis_report.txt"
    done

    # Calculate correctness score
    correctly_classified=$(cat "$ROOT_FOLDER/correctly_classified.txt" 2>/dev/null | wc -l)
    correctness=$(awk "BEGIN {printf \"%.2f\", ($correctly_classified/$total_files)*100}")
    echo "" >> "$ROOT_FOLDER/analysis_report.txt"
    echo "Correctness Score: $correctness%" >> "$ROOT_FOLDER/analysis_report.txt"
    echo "Report generated: $ROOT_FOLDER/analysis_report.txt"
}

# Generate analysis report if requested
if [ "$REPORT" -eq 1 ]; then
    generate_report
fi
