#!/usr/bin/env python3

# organize_pdfs.py - Advanced PDF Organizer using NLP

import os
import sys
import json
import shutil
import argparse
import multiprocessing
from pdfminer.high_level import extract_text
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from collections import defaultdict
from tqdm import tqdm

# Function to parse command-line arguments
def parse_arguments():
    parser = argparse.ArgumentParser(description='Advanced PDF Organizer using NLP')
    parser.add_argument('--root', required=True, help='Root folder containing PDF files')
    parser.add_argument('--report', action='store_true', help='Generate an analysis report after organizing')
    return parser.parse_args()

# Function to load configuration from config.json
def load_configuration(config_file):
    if not os.path.isfile(config_file):
        print(f'Configuration file {config_file} not found!')
        sys.exit(1)

    with open(config_file, 'r') as f:
        config = json.load(f)
    return config

# Function to create directories for categories and subcategories
def create_directories(root_folder, config):
    for category, subcats in config.items():
        for subcat in subcats.keys():
            os.makedirs(os.path.join(root_folder, category, subcat), exist_ok=True)
    os.makedirs(os.path.join(root_folder, 'Others'), exist_ok=True)

# Function to preprocess text
def preprocess_text(text):
    tokens = word_tokenize(text.lower())
    stop_words = set(stopwords.words('english'))
    words = [word for word in tokens if word.isalnum() and word not in stop_words]
    return words

# Function to classify a single PDF file
def classify_file(args):
    file_path, config, root_folder = args
    filename = os.path.basename(file_path)
    best_score = 0
    best_category = 'Others'
    best_subcategory = ''
    content_words = []

    try:
        text = extract_text(file_path)
        content_words = preprocess_text(text)
    except Exception as e:
        print(f'Error processing {filename}: {e}')
        shutil.move(file_path, os.path.join(root_folder, 'Others'))
        return 'Others'

    category_scores = defaultdict(int)

    for category, subcats in config.items():
        for subcat, keywords in subcats.items():
            score = sum(content_words.count(keyword.lower()) for keyword in keywords)
            category_scores[(category, subcat)] += score
            # Debug: print score for each subcategory
            print(f'Score for {category}/{subcat} in {filename}: {score}')
            if score > best_score:
                best_score = score
                best_category = category
                best_subcategory = subcat

    if best_score > 0:
        dest_dir = os.path.join(root_folder, best_category, best_subcategory)
    else:
        dest_dir = os.path.join(root_folder, 'Others')

    shutil.move(file_path, dest_dir)
    return best_category if best_score > 0 else 'Others'

# Function to generate analysis report
def generate_report(root_folder, config):
    total_files = 0
    category_counts = defaultdict(int)

    for category, subcats in config.items():
        for subcat in subcats.keys():
            subcat_dir = os.path.join(root_folder, category, subcat)
            num_files = len([name for name in os.listdir(subcat_dir) if name.endswith('.pdf')])
            category_counts[category] += num_files
            total_files += num_files

    # Count files in 'Others' category
    others_dir = os.path.join(root_folder, 'Others')
    others_files = len([name for name in os.listdir(others_dir) if name.endswith('.pdf')])
    total_files += others_files
    category_counts['Others'] = others_files

    # Generate report
    report = 'Analysis Report:\n----------------\n'
    for category in config.keys():
        percentage = (category_counts[category] / total_files) * 100 if total_files > 0 else 0
        report += f'{category}: {percentage:.2f}%\n'
    # Add 'Others'
    others_percentage = (category_counts['Others'] / total_files) * 100 if total_files > 0 else 0
    report += f'Others: {others_percentage:.2f}%\n'
    print(report)

def main():
    args = parse_arguments()
    root_folder = args.root
    config_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.json')
    config = load_configuration(config_file)
    create_directories(root_folder, config)

    # Prepare arguments for multiprocessing
    pdf_files = [os.path.join(root_folder, f) for f in os.listdir(root_folder) if f.endswith('.pdf')]
    pool_args = [(file_path, config, root_folder) for file_path in pdf_files]

    # Download NLTK data
    import nltk
    nltk.download('punkt', quiet=True)
    nltk.download('stopwords', quiet=True)

    # Use multiprocessing pool for parallel processing
    with multiprocessing.Pool(processes=multiprocessing.cpu_count()) as pool:
        results = list(tqdm(pool.imap(classify_file, pool_args), total=len(pool_args)))

    # Generate report if requested
    if args.report:
        generate_report(root_folder, config)

if __name__ == '__main__':
    main()
