set -e
set -o pipefail
ROOT_FOLDER=""
REPORT=0
print_usage() {
    echo "Usage: $0 --root /path/to/root_folder [--report]"
    echo "Options:"
    echo "  --root    Specify the root folder containing PDF files."
    echo "  --report  Generate an analysis report after organizing."
}
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
if [ -z "$ROOT_FOLDER" ]; then
    echo "Error: Root folder not specified."
    print_usage
    exit 1
fi
categories=("Programming" "AI" "Math" "Database" "Security")
get_subcategories() {
    local category="$1"
    case "$category" in
        Programming) echo "Python Java C" ;;
        AI) echo "Machine_Learning Neural_Networks" ;;
        Math) echo "Linear_Algebra Calculus" ;;
        Database) echo "SQL NoSQL" ;;
        Security) echo "Cryptography Network_Security" ;;
        *) echo "" ;;
    esac
}
create_directories() {
    mkdir -p "$ROOT_FOLDER/Others"
    for category in "${categories[@]}"; do
        mkdir -p "$ROOT_FOLDER/$category"
        subcats=$(get_subcategories "$category")
        for subcat in $subcats; do
            mkdir -p "$ROOT_FOLDER/$category/$subcat"
        done
    done
}
categorize_files() {
    echo "Processing files..."
    find "$ROOT_FOLDER" -maxdepth 1 -type f -iname "*.pdf" | while read -r file; do
        filename=$(basename "$file")
        base_filename="${filename%.*}"  # Remove extension
        base_filename="${base_filename//_/ }"  # Replace underscores with spaces
        base_filename=" $base_filename "  # Add spaces at the beginning and end
        moved=0
        for category in "${categories[@]}"; do
            subcats=$(get_subcategories "$category")
            for subcat in $subcats; do
                subcat_pattern="${subcat//_/ }"  # Replace underscores with spaces
                shopt -s nocasematch
                if [[ "$base_filename" =~ [[:space:]]$subcat_pattern[[:space:]] ]]; then
                    echo "Moving file '$file' to '$ROOT_FOLDER/$category/$subcat/'"
                    mv "$file" "$ROOT_FOLDER/$category/$subcat/"
                    moved=1
                    shopt -u nocasematch
                    break 2  # Break out of both loops
                fi
                shopt -u nocasematch
            done
        done
        if [ $moved -eq 0 ]; then
            echo "Moving unclassified file '$file' to '$ROOT_FOLDER/Others/'"
            mv "$file" "$ROOT_FOLDER/Others/"
        fi
    done
}
generate_report() {
    total_files=$(find "$ROOT_FOLDER" -type f -iname "*.pdf" | wc -l)
    if [ "$total_files" -eq 0 ]; then
        echo "No PDF files found in the root directory."
        exit 1
    fi
    echo "Analysis Report:" > analysis_report.txt
    echo "----------------" >> analysis_report.txt
    for category in "${categories[@]}"; do
        count=$(find "$ROOT_FOLDER/$category" -type f -iname "*.pdf" | wc -l)
        percentage=$((count * 100 / total_files))
        echo "$category: $percentage%" >> analysis_report.txt
    done
    others_count=$(find "$ROOT_FOLDER/Others" -type f -iname "*.pdf" | wc -l)
    others_percentage=$((others_count * 100 / total_files))
    echo "Others: $others_percentage%" >> analysis_report.txt
    correctness=$((100 - others_percentage))
    echo "" >> analysis_report.txt
    echo "Correctness Score: $correctness%" >> analysis_report.txt
    echo "Report generated: analysis_report.txt"
}
create_directories
categorize_files
if [ "$REPORT" -eq 1 ]; then
    generate_report
fi
