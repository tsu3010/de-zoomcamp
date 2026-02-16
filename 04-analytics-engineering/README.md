# Data Engineering Zoomcamp - Module 4: Analytics Engineering

## 📋 Overview

This module covers analytics engineering with dbt (data build tool) using NYC Taxi data for 2019-2020.

### Project Configuration
- **GCP Project**: `dtc-de-course-486009`
- **BigQuery Dataset**: `nytaxi`
- **GCS Bucket**: `dtc-decourse-dbt-nytaxi`
- **Data**: Green & Yellow taxi trips (2019-2020) - 48 CSV files

### Quick Links
- 📖 **[Complete Setup Guide](data_setup.md)** - Step-by-step instructions for data setup
- 🐍 **[load_taxi_data.py](load_taxi_data.py)** - Python script to upload data to GCS
- 📊 **[create_bq_tables.sql](create_bq_tables.sql)** - SQL to create BigQuery tables

---

## 🚀 Quick Start

### 1. Upload Data to GCS
```bash
cd 04-analytics-engineering

# Authenticate with GCP
gcloud auth application-default login

# Create bucket (if needed)
gsutil mb -p dtc-de-course-486009 -l US gs://dtc-decourse-dbt-nytaxi

# Run upload script with UV
uv run load_taxi_data.py
```

### 2. Create BigQuery Tables
```bash
# Run SQL script
bq query --use_legacy_sql=false < create_bq_tables.sql
```

### 3. Set up dbt
Follow the dbt Cloud setup instructions below.

---

## 📚 Detailed Guides

### Data Setup
For complete data setup instructions, see **[data_setup.md](data_setup.md)**

### dbt Setup
This guide contains setup instructions for the Analytics Engineering module using dbt

## 📺 DE Zoomcamp 4.2.2 - Cloud Setup (Alternative A)
Goal: Configure a production-ready environment using Google Cloud Platform (GCP) and dbt Cloud.

1. Google Cloud Platform (GCP) Configuration
Enable BigQuery API: Ensure the BigQuery API is active in your GCP project search bar.

Create Service Account: * Navigate to IAM & Admin > Service Accounts.

Create a dedicated account (e.g., dbt-bigquery-sa) rather than using personal credentials.

Assign IAM Roles: Use the "Least Privilege" principle by assigning these three specific roles:

BigQuery Data Editor

BigQuery Job User

BigQuery User

Generate JSON Key: Create a new JSON key for the service account, download it, and keep it private.

2. dbt Cloud (Platform) Setup
Project Initialization: Create a new project in dbt Cloud and select BigQuery as your connection.

Credentials: Upload your Service Account JSON key to automatically fill in the connection details.

Environment Settings: * Set up a Development Environment.

Define a unique dataset name (e.g., dbt_yourname) to ensure your transformations are isolated from others.

Repository: Connect your GitHub account or use a dbt-managed repository.

Finalize: Click "Initialize dbt project" and create a new branch to begin coding.