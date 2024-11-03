
# Multi-Level PDF File Organizer Using Threading and Scripting

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Clone the Repository](#clone-the-repository)
  - [Build and Install the Tool](#build-and-install-the-tool)
- [Usage](#usage)
  - [Generating Sample PDFs](#generating-sample-pdfs)
  - [Organizing PDFs](#organizing-pdfs)
  - [Deleting PDFs](#deleting-pdfs)
  - [Analysis Report](#analysis-report)
- [GitHub Actions CI/CD](#github-actions-cicd)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Author](#author)

---

## Overview

The **Multi-Level PDF File Organizer** is a Bash-based tool designed to efficiently manage and organize PDF files within a specified root directory. It categorizes PDFs into predefined categories and subcategories, utilizes multi-threading for enhanced performance, and generates detailed analysis reports on the organization process. Additionally, it includes scripts for generating sample PDFs and deleting existing PDFs, facilitating comprehensive testing and maintenance.

## Features

- **File Categorization**: Automatically organizes PDF files into six main categories—**Programming**, **AI**, **Math**, **Database**, **Security**, and **Others**—each with relevant subcategories.
- **Multi-Threading**: Employs background processes to handle file organization concurrently, improving efficiency, especially with large numbers of files.
- **Sample PDF Generation**: Includes a script to generate sample PDFs for testing the organizer tool.
- **PDF Deletion**: Provides a script to delete all PDF files within specified directories.
- **Analysis Report**: Generates a report detailing the percentage distribution of PDFs across categories and a correctness score evaluating the organization accuracy.
- **Packaging for Kali Linux**: Optionally packaged as a Debian package for easy installation on Kali Linux and other Debian-based distributions.
- **Continuous Integration**: Utilizes GitHub Actions for automated building and testing of the tool.

## Project Structure

```
organize-pdfs/
├── .github/
│   └── workflows/
│       └── makefile.yml
├── bin/
│   ├── delete_pdfs.sh
│   ├── generate_sample_pdfs.sh
│   ├── organize_pdfs.sh
├── Makefile
├── README.md
├── LICENSE
└── ... (other project files)
```

- **`.github/workflows/makefile.yml`**: GitHub Actions workflow for CI/CD.
- **`bin/`**: Directory containing all executable scripts.
  - **`generate_sample_pdfs.sh`**: Generates sample PDF files for testing.
  - **`organize_pdfs.sh`**: Organizes PDFs into categories and subcategories.
  - **`delete_pdfs.sh`**: Deletes all PDF files from specified directories.
- **`Makefile`**: Automates building, packaging, and installation processes.
- **`README.md`**: Documentation file.
- **`LICENSE`**: License information.

## Installation

### Prerequisites

- **Operating System**: Kali Linux or any Debian-based Linux distribution.
- **Dependencies**:
  - Bash shell
  - `make`
  - `dpkg-dev`
  - `pandoc`
  - `libreoffice` (optional, if using LibreOffice for PDF conversion)
  - `ghostscript` and `texlive` (for advanced PDF handling)

### Clone the Repository

```bash
git clone https://github.com/yourusername/organize-pdfs.git
cd organize-pdfs
```

### Build and Install the Tool

The project includes a `Makefile` to automate the building and installation process.

1. **Make the Scripts Executable**

   Ensure all scripts have execute permissions:

   ```bash
   chmod +x bin/*.sh
   ```

2. **Build the Debian Package**

   ```bash
   make
   ```

   This command will:
   - Clean any previous builds.
   - Create necessary directories.
   - Copy scripts to `/usr/bin/`.
   - Generate the `control` file with package metadata.
   - Build the Debian package using `dpkg-deb`.
   - The resulting `.deb` file will be named `organize-pdfs_1.0.0_all.deb`.

3. **Install the Package**

   ```bash
   sudo dpkg -i organize-pdfs_1.0.0_all.deb
   ```

4. **Resolve Dependencies (If Any)**

   If there are dependency issues, run:

   ```bash
   sudo apt-get install -f
   ```

5. **Verify Installation**

   Check if the `organize_pdfs` command is available:

   ```bash
   which organize_pdfs
   ```

   This should output `/usr/bin/organize_pdfs`.

## Usage

The tool provides three main functionalities:

1. **Generating Sample PDFs**
2. **Organizing PDFs**
3. **Deleting PDFs**

Each functionality is accessed via its respective script.

### Generating Sample PDFs

Use the `generate_sample_pdfs.sh` script to create sample PDF files for testing the organizer tool.

**Command:**

```bash
./bin/generate_sample_pdfs.sh /path/to/output_directory
```

**Example:**

```bash
./bin/generate_sample_pdfs.sh ./test_root_folder
```

**Description:**

- Creates a specified output directory (e.g., `test_root_folder`).
- Generates `.txt` files with sample content for each category and subcategory.
- Converts `.txt` files to `.pdf` using `pandoc`.
- Removes the original `.txt` files after conversion.

### Organizing PDFs

Use the `organize_pdfs.sh` script to categorize and organize PDF files within the root directory.

**Command:**

```bash
./bin/organize_pdfs.sh --root /path/to/root_folder [--report]
```

**Options:**

- `--root`: **(Required)** Specifies the root directory containing PDF files to organize.
- `--report`: **(Optional)** Generates an analysis report after organizing.

**Example:**

```bash
./bin/organize_pdfs.sh --root ./test_root_folder --report
```

**Description:**

- Creates necessary category and subcategory directories within the root folder.
- Uses multi-threading (background processes) to categorize PDFs efficiently.
- Moves PDFs into appropriate subcategory directories based on filename keywords.
- Generates an `analysis_report.txt` detailing the distribution of PDFs and a correctness score.

### Deleting PDFs

Use the `delete_pdfs.sh` script to remove all PDF files from specified directories.

**Command:**

```bash
./bin/delete_pdfs.sh
```

**Description:**

- Searches through predefined directories (`AI`, `Programming`, `Database`, `Security`, `Math`, `Others`) within the root folder.
- Deletes all `.pdf` files found in these directories.
- Provides a confirmation message upon successful deletion.

**Note:** Ensure you have the correct permissions and specify the appropriate root directory if required.

### Analysis Report

When using the `--report` option with the `organize_pdfs.sh` script, an `analysis_report.txt` is generated in the root folder. This report includes:

- **Percentage of Files per Category:** Shows the distribution of PDFs across all categories.
- **Correctness Score:** Indicates the accuracy of the categorization based on predefined rules.

**Example Report:**

```
Analysis Report:
----------------
Programming: 20.00%
Math: 13.33%
Others: 26.67%
AI: 13.33%
Database: 13.33%
Security: 13.33%

Correctness Score: 73.33%
Report generated: /path/to/root_folder/analysis_report.txt
```

## GitHub Actions CI/CD

The project utilizes GitHub Actions for continuous integration and deployment. The workflow is defined in `.github/workflows/makefile.yml`.

### Workflow Overview

- **Triggers:**
  - On push to the `main` branch.
  - On pull requests targeting the `main` branch.

- **Jobs:**
  1. **Checkout Repository:** Clones the repository.
  2. **Set Up Environment:** Installs necessary dependencies.
  3. **Build the Package:** Compiles and packages the tool.
  4. **Install the Package:** Installs the compiled Debian package.
  5. **Generate Sample PDFs:** Runs the script to create sample PDFs.
  6. **List Directory Contents:** Verifies the presence of generated PDFs.
  7. **Run Organizer Script:** Organizes the generated PDFs and creates an analysis report.
  8. **Display Analysis Report:** Outputs the report to the workflow logs.
  9. **Uninstall the Package:** Cleans up by removing the installed package.
  10. **Clean Up:** Removes build artifacts.

### Workflow File

```yaml
name: Build and Test

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Set up Environment
        run: |
          sudo apt-get update
          sudo apt-get install -y make dpkg-dev pandoc

      - name: Build the Package
        run: make

      - name: Install the Package
        run: sudo dpkg -i organize-pdfs_1.0.0_all.deb

      - name: Generate Sample PDFs
        run: |
          chmod +x bin/generate_sample_pdfs.sh
          ./bin/generate_sample_pdfs.sh test_root_folder

      - name: List Contents of test_root_folder
        run: ls -la test_root_folder

      - name: Run the Organizer Script
        run: organize_pdfs --root test_root_folder --report

      - name: Display Analysis Report
        run: cat test_root_folder/analysis_report.txt

      - name: Uninstall the Package
        run: sudo make uninstall

      - name: Clean Up
        run: make clean
```

### Setting Up GitHub Actions

1. **Create Workflow Directory:**

   Ensure the workflow file is located at `.github/workflows/makefile.yml`.

2. **Commit and Push:**

   ```bash
   git add .github/workflows/makefile.yml
   git commit -m "Add GitHub Actions workflow for CI/CD"
   git push origin main
   ```

3. **Monitor Workflow:**

   Navigate to the **Actions** tab in your GitHub repository to monitor the workflow's execution and review logs.

## Troubleshooting

If you encounter issues while running the scripts or during the CI/CD process, consider the following solutions:

### Common Errors and Solutions

1. **Permission Denied**

   - **Error:**
     ```
     mkdir: cannot create directory ‘/home/mohd’: Permission denied
     ```
   - **Solution:**
     - Ensure you're specifying a directory within your user space.
     - Modify the script to use relative paths or directories you have write access to.
     - Example:
       ```bash
       ./bin/generate_sample_pdfs.sh ./test_root_folder
       ```

2. **Command Not Found**

   - **Error:**
     ```
     libreoffice: command not found
     ```
   - **Solution:**
     - Install `libreoffice` or switch to `pandoc` for PDF conversion.
     - Update the workflow and scripts accordingly.
     - Install `pandoc`:
       ```bash
       sudo apt-get install -y pandoc
       ```
     - Modify `generate_sample_pdfs.sh` to use `pandoc`:
       ```bash
       pandoc "$OUTPUT_DIR/$filename.txt" -o "$OUTPUT_DIR/$filename.pdf"
       ```

3. **No PDF Files Found**

   - **Error:**
     ```
     No PDF files found in the root directory.
     ```
   - **Solution:**
     - Verify that the `generate_sample_pdfs.sh` script is executing correctly and generating PDFs in the specified directory.
     - Check directory paths and permissions.
     - Ensure dependencies like `pandoc` are installed and functional.

4. **File Not Found During Removal**

   - **Error:**
     ```
     rm: cannot remove '/home/mohd/test_root_folder/Math_Linear_Algebra.txt': No such file or directory
     ```
   - **Solution:**
     - This error occurs because the `.txt` files were not created due to earlier errors.
     - Resolve previous issues (e.g., permission denied, command not found) to ensure `.txt` files are generated before conversion and removal.

### Best Practices

- **Use Relative Paths:** Avoid hardcoding absolute paths to prevent permission issues.
- **Error Handling:** Incorporate `set -e` and `set -o pipefail` at the beginning of your scripts to ensure they exit on errors.
- **Log Outputs:** Add `echo` statements to log progress and help identify where failures occur.
- **Test Locally:** Before pushing changes, run scripts locally to ensure they work as expected.

## Contributing

Contributions are welcome! If you'd like to enhance the tool, fix bugs, or improve documentation, please follow these steps:

1. **Fork the Repository**

   Click the **Fork** button at the top-right of the repository page on GitHub.

2. **Clone Your Fork**

   ```bash
   git clone https://github.com/yourusername/organize-pdfs.git
   cd organize-pdfs
   ```

3. **Create a New Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make Your Changes**

   Edit the scripts, Makefile, or documentation as needed.

5. **Commit Your Changes**

   ```bash
   git add .
   git commit -m "Describe your changes"
   ```

6. **Push to Your Fork**

   ```bash
   git push origin feature/your-feature-name
   ```

7. **Open a Pull Request**

   Navigate to your fork on GitHub and click **Compare & pull request**.

8. **Await Review**

   Project maintainers will review your contribution and provide feedback or merge your changes.

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute it as per the license terms.

## Author

- **MohammadThabet** – [MohammadThabet](https://github.com/MohammadThabetHassan)

---

## Additional Notes

- **Environment Variables:** The `generate_sample_pdfs.sh` script uses the `GITHUB_WORKSPACE` environment variable, which is set by GitHub Actions. Ensure that when running locally, you provide the appropriate output directory.
  
- **Packaging:** The provided `Makefile` automates the packaging process. Customize the `control` file within the `Makefile` as needed, especially the `Maintainer` and `Description` fields.

- **GitHub Actions:** The CI/CD workflow assumes the presence of certain dependencies. Ensure that your scripts are compatible with headless environments like CI runners.

- **Script Permissions:** Always ensure that your scripts have the necessary execute permissions (`chmod +x script.sh`) before running or packaging them.

- **Testing:** Regularly test your scripts locally to catch and fix issues before pushing changes to the repository.


