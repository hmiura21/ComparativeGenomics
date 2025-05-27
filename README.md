# Comparative Genomics Outbreak Analysis

## 🧬 Overview

This project investigates a potential outbreak by analyzing 10 Illumina-sequenced bacterial isolates from NCBI's SRA database. A whole-genome SNP-based phylogenetic tree was constructed to determine which isolates were part of the outbreak and which were distant outliers.

---

## 📂 Project Structure
comparative/
├── tree.png # Phylogenetic tree (can be .png, .svg, or .pdf)
├── outliers.txt # Plain text list of unrelated samples (SRA accessions)
├── cmds.sh # All shell commands used, with comments
└── README.md # Project summary and structure (this file)

---

## 🔍 Objectives

- Download and process Illumina data from 10 SRA accessions.
- Perform comparative genomics using `parsnp` 
- Generate a phylogenetic tree to identify outbreak-related isolates.
- Identify outliers based on genomic distance.

---

## 📥 Data Download

All 10 Illumina datasets were downloaded using the `fasterq-dump` tool 
