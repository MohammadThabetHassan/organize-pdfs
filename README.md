
# Organize PDFs

## Description

Organize PDFs is a Bash script that organizes PDF files in a root folder into predefined categories and subcategories. It uses background processes to handle file organization efficiently and generates an analysis report based on the distribution of files.

## Features

- **File Categorization**: Organizes PDFs into six main categories: Programming, AI, Math, Database, Security, and Others.
- **Multi-threading**: Utilizes background processes to handle large numbers of files efficiently.
- **Analysis Report**: Generates a report showing the percentage of files in each category and a correctness score.

## Installation

### Prerequisites

- **Operating System**: Kali Linux or any Debian-based Linux distribution.
- **Dependencies**: Bash shell.

### From Source

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/organize-pdfs.git
   ```

2. **Navigate to the project directory**:

   ```bash
   cd organize-pdfs
   ```

3. **Build and install the package**:

   ```bash
   make
   sudo make install
   ```

## Usage

```bash
organize_pdfs --root /path/to/root_folder --report
```

- `--root`: Specify the root folder containing PDF files.
- `--report`: (Optional) Generate an analysis report after organizing.

## Uninstallation

To uninstall the tool:

```bash
sudo make uninstall
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome. Please open an issue to discuss what you would like to change.

## Author

- **Your Name** - [yourusername](https://github.com/yourusername)

```
