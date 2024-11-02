#!/usr/bin/env python3

from reportlab.lib.pagesizes import LETTER
from reportlab.pdfgen import canvas
import os

# Set the root folder
ROOT_FOLDER = "/home/mohd/test_root_folder"

# Create the root folder if it doesn't exist
os.makedirs(ROOT_FOLDER, exist_ok=True)

# Define categories, subcategories, and sample content
samples = {
    "Programming/Python": "This is a Python programming tutorial. It covers scripting and py files.",
    "Programming/Java": "Learn about Java programming, JVM, and JDK in this document.",
    "Programming/C": "C programming guide with pointers and memory allocation.",
    "AI/Machine_Learning": "An introduction to machine learning, supervised and unsupervised learning.",
    "AI/Neural_Networks": "Deep learning with neural networks and backpropagation techniques.",
    "Math/Linear_Algebra": "Study linear algebra, matrices, vectors, and eigenvalues.",
    "Math/Calculus": "Calculus basics including derivatives, integrals, and limits.",
    "Database/SQL": "SQL queries, relational databases, and joins explained.",
    "Database/NoSQL": "Introduction to NoSQL databases like MongoDB and Cassandra.",
    "Security/Cryptography": "Cryptography concepts including encryption and decryption.",
    "Security/Network_Security": "Network security principles, firewalls, and intrusion detection.",
    "Others": "General knowledge document without specific keywords."
}

# Generate sample PDFs
for category_subcategory, content in samples.items():
    filename = category_subcategory.replace("/", "_") + ".pdf"
    filepath = os.path.join(ROOT_FOLDER, filename)
    c = canvas.Canvas(filepath, pagesize=LETTER)
    c.setFont("Helvetica-Bold", 14)
    c.drawString(100, 750, category_subcategory)
    text = c.beginText(100, 730)
    text.setFont("Helvetica", 12)
    text.textLines(content)
    c.drawText(text)
    c.save()
    print(f"Generated PDF: {filepath}")

# Generate additional random PDFs for the 'Others' category
for i in range(1, 4):
    filename = f"Others_Document_{i}.pdf"
    filepath = os.path.join(ROOT_FOLDER, filename)
    c = canvas.Canvas(filepath, pagesize=LETTER)
    c.setFont("Helvetica-Bold", 14)
    c.drawString(100, 750, f"Others Document {i}")
    text = c.beginText(100, 730)
    text.setFont("Helvetica", 12)
    text.textLines("This is a general document without specific category keywords.")
    c.drawText(text)
    c.save()
    print(f"Generated PDF: {filepath}")
