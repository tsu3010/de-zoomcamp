# NYC Taxi Data Setup Guide

Complete guide for setting up NYC taxi data (green and yellow) for 2019-2020 in Google Cloud Platform for analytics engineering.

---

## 📋 Overview

This setup will:
1. ✅ Download 48 CSV files from GitHub (green & yellow taxi data for 2019-2020)
2. ✅ Upload files to Google Cloud Storage
3. ✅ Create BigQuery external tables (point to GCS files)
4. ✅ Create BigQuery native partitioned tables (for better performance)

### Project Configuration
- **GCP Project ID**: `dtc-de-course-486009`
- **BigQuery Dataset**: `nytaxi`
- **GCS Bucket**: `dtc-decourse-dbt-nytaxi`
- **Data Source**: [NYC TLC Data GitHub](https://github.com/DataTalksClub/nyc-tlc-data/releases)

### Data Volume
- **Taxi Types**: Green, Yellow
- **Years**: 2019, 2020
- **Total Files**: 48 (2 types × 2 years × 12 months)

---

## 🚀 Part 1: GCP Setup

### Step 1.1: Install Google Cloud SDK (if not installed)

Download and install from: https://cloud.google.com/sdk/docs/install

### Step 1.2: Authenticate

```bash
# Login to GCP
gcloud auth login

# Set application default credentials
gcloud auth application-default login

# Set your project
gcloud config set project dtc-de-course-486009

# Verify configuration
gcloud config list
```

### Step 1.3: Create BigQuery Dataset

```bash
# Create dataset
bq mk --location=US --dataset dtc-de-course-486009:nytaxi

# Verify dataset exists
bq ls --project_id=dtc-de-course-486009
```

### Step 1.4: Create GCS Bucket

```bash
# Create bucket
gsutil mb -p dtc-de-course-486009 -l US gs://dtc-decourse-dbt-nytaxi

# Verify bucket exists
gsutil ls
```

---

## 📥 Part 2: Upload Data to GCS

### Step 2.1: Install UV (Python Package Manager)

**On Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Or using pip:**
```bash
pip install uv
```

### Step 2.2: Navigate to Project Directory

```bash
cd 04-analytics-engineering
```

### Step 2.3: Run Upload Script

**Option A: Quick run (UV handles everything)**
```bash
uv run load_taxi_data.py
```

**Option B: Manual setup**
```bash
# Install dependencies
uv sync

# Run script
uv run python load_taxi_data.py
```

### Expected Output

```
============================================================
NYC Taxi Data Upload to GCS
============================================================

Checking GCS bucket...
Bucket gs://dtc-decourse-dbt-nytaxi exists and is accessible

Starting upload of 48 files...
Taxi types: green, yellow
Years: 2019, 2020
Months: 01-12

============================================================
[1/48] Processing green taxi 2019-01
============================================================
Downloading https://github.com/...
Decompressing green_tripdata_2019-01.csv.gz
Successfully downloaded and decompressed green_tripdata_2019-01.csv
Uploading green_tripdata_2019-01.csv to gs://dtc-decourse-dbt-nytaxi/...
Successfully uploaded to gs://dtc-decourse-dbt-nytaxi/green_tripdata_2019-01.csv
...
```

### Step 2.4: Verify Upload

```bash
# List all uploaded files
gsutil ls gs://dtc-decourse-dbt-nytaxi/

# Should show 48 CSV files:
# gs://dtc-decourse-dbt-nytaxi/green_tripdata_2019-01.csv
# gs://dtc-decourse-dbt-nytaxi/green_tripdata_2019-02.csv
# ...
# gs://dtc-decourse-dbt-nytaxi/yellow_tripdata_2020-12.csv

# Count files
gsutil ls gs://dtc-decourse-dbt-nytaxi/*.csv | wc -l
# Should output: 48
```

---

## 🗄️ Part 3: Create BigQuery Tables

### Step 3.1: Open BigQuery Console

Go to: https://console.cloud.google.com/bigquery

Or use `bq` command line tool.

### Step 3.2: Run SQL Script

**Option A: Using BigQuery Console**
1. Open BigQuery in GCP Console
2. Click "+ COMPOSE NEW QUERY"
3. Copy and paste contents from `create_bq_tables.sql`
4. Click "RUN"

**Option B: Using `bq` command line**
```bash
# Run the entire SQL file
bq query --use_legacy_sql=false < create_bq_tables.sql
```

**Option C: Run each section separately**

Create external tables:
```bash
bq query --use_legacy_sql=false '
CREATE OR REPLACE EXTERNAL TABLE `dtc-de-course-486009.nytaxi.green_tripdata_external`
(
    VendorID STRING,
    lpep_pickup_datetime TIMESTAMP,
    lpep_dropoff_datetime TIMESTAMP,
    store_and_fwd_flag STRING,
    RatecodeID STRING,
    PULocationID STRING,
    DOLocationID STRING,
    passenger_count INT64,
    trip_distance NUMERIC,
    fare_amount NUMERIC,
    extra NUMERIC,
    mta_tax NUMERIC,
    tip_amount NUMERIC,
    tolls_amount NUMERIC,
    ehail_fee NUMERIC,
    improvement_surcharge NUMERIC,
    total_amount NUMERIC,
    payment_type INT64,
    trip_type STRING,
    congestion_surcharge NUMERIC
)
OPTIONS (
    format = "CSV",
    uris = ["gs://dtc-decourse-dbt-nytaxi/green_tripdata_*.csv"],
    skip_leading_rows = 1
);
'
```

### Step 3.3: Verify Tables Created

```bash
# List all tables in the dataset
bq ls dtc-de-course-486009:nytaxi

# Should show:
# - green_tripdata_external
# - greentrip_data
# - yellow_tripdata_external
# - yellowtrip_data

# Check table schemas
bq show dtc-de-course-486009:nytaxi.greentrip_data
bq show dtc-de-course-486009:nytaxi.yellowtrip_data
```

### Step 3.4: Verify Data Loaded

Run verification queries from `create_bq_tables.sql`:

```sql
-- Check row counts
SELECT 'Green Taxi' AS table_name, COUNT(*) AS row_count
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
UNION ALL
SELECT 'Yellow Taxi', COUNT(*)
FROM `dtc-de-course-486009.nytaxi.yellowtrip_data`;

-- Check date ranges
SELECT
    'Green Taxi' AS taxi_type,
    MIN(DATE(lpep_pickup_datetime)) AS min_date,
    MAX(DATE(lpep_pickup_datetime)) AS max_date
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
UNION ALL
SELECT
    'Yellow Taxi',
    MIN(DATE(tpep_pickup_datetime)),
    MAX(DATE(tpep_pickup_datetime))
FROM `dtc-de-course-486009.nytaxi.yellowtrip_data`;
```

---

## 📊 Part 4: Table Descriptions

### External Tables (Query GCS directly)

| Table | Description | Storage |
|-------|-------------|---------|
| `green_tripdata_external` | External table pointing to green taxi CSV files in GCS | GCS |
| `yellow_tripdata_external` | External table pointing to yellow taxi CSV files in GCS | GCS |

**Pros**: No storage cost in BigQuery, data stays in GCS
**Cons**: Slower queries, can't use partitioning benefits

### Native Tables (Stored in BigQuery)

| Table | Description | Partitioning |
|-------|-------------|--------------|
| `greentrip_data` | Green taxi data stored in BigQuery | Partitioned by `lpep_pickup_datetime` (day) |
| `yellowtrip_data` | Yellow taxi data stored in BigQuery | Partitioned by `tpep_pickup_datetime` (day) |

**Pros**: Much faster queries, better performance, supports partitioning
**Cons**: Storage cost in BigQuery

### Column Schemas

**Green Taxi (`greentrip_data`)**
- `unique_row_id`: BYTES - MD5 hash for deduplication
- `VendorID`: STRING - Provider code
- `lpep_pickup_datetime`: TIMESTAMP - Pickup time
- `lpep_dropoff_datetime`: TIMESTAMP - Dropoff time
- `passenger_count`: INT64 - Number of passengers
- `trip_distance`: NUMERIC - Distance in miles
- `fare_amount`: NUMERIC - Fare
- `total_amount`: NUMERIC - Total charged
- And more... (see schema in SQL file)

**Yellow Taxi (`yellowtrip_data`)**
- Similar schema but uses `tpep_pickup_datetime` instead of `lpep_pickup_datetime`

---

## 🧪 Part 5: Test Queries

### Basic Queries

```sql
-- Count trips per month (Green)
SELECT
    DATE_TRUNC(lpep_pickup_datetime, MONTH) AS month,
    COUNT(*) AS trip_count
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
GROUP BY month
ORDER BY month;

-- Average fare by taxi type
SELECT
    'Green' AS taxi_type,
    AVG(fare_amount) AS avg_fare,
    AVG(trip_distance) AS avg_distance
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
UNION ALL
SELECT
    'Yellow',
    AVG(fare_amount),
    AVG(trip_distance)
FROM `dtc-de-course-486009.nytaxi.yellowtrip_data`;

-- Top pickup locations (Green)
SELECT
    PULocationID,
    COUNT(*) AS trip_count
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
WHERE PULocationID IS NOT NULL
GROUP BY PULocationID
ORDER BY trip_count DESC
LIMIT 10;
```

---

## 📁 Files in this Directory

| File | Description |
|------|-------------|
| `load_taxi_data.py` | Python script to download and upload data to GCS |
| `create_bq_tables.sql` | SQL to create BigQuery tables from GCS files |
| `pyproject.toml` | UV/Python project configuration |
| `requirements.txt` | Python dependencies |
| `data_setup.md` | This file - complete setup guide |
| `README.md` | Project overview and quick start |

---

## 🔧 Troubleshooting

### Issue: Authentication Error

```bash
# Re-authenticate
gcloud auth application-default login
gcloud auth login
```

### Issue: Bucket Access Denied

```bash
# Check bucket permissions
gsutil iam get gs://dtc-decourse-dbt-nytaxi

# Add yourself as admin (if needed)
gsutil iam ch user:your-email@gmail.com:roles/storage.admin gs://dtc-decourse-dbt-nytaxi
```

### Issue: BigQuery Permission Denied

Make sure your account has these roles:
- BigQuery Data Editor
- BigQuery Job User
- Storage Object Viewer (for external tables)

```bash
# Grant roles (run as project owner)
gcloud projects add-iam-policy-binding dtc-de-course-486009 \
    --member="user:your-email@gmail.com" \
    --role="roles/bigquery.dataEditor"

gcloud projects add-iam-policy-binding dtc-de-course-486009 \
    --member="user:your-email@gmail.com" \
    --role="roles/bigquery.jobUser"
```

### Issue: Download/Upload Failed

- Check internet connection
- Verify GCS bucket exists: `gsutil ls`
- Check if files already exist: `gsutil ls gs://dtc-decourse-dbt-nytaxi/`
- Re-run the script (it will skip existing files)

---

## 🎯 Next Steps

After completing this setup, you can:

1. **Use dbt (Data Build Tool)** to create models and transformations
2. **Build dashboards** in Looker, Tableau, or Data Studio
3. **Run analytics queries** in BigQuery
4. **Create ML models** with BigQuery ML
5. **Export to other tools** for further analysis

---

## 📚 Resources

- [NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [GCS Documentation](https://cloud.google.com/storage/docs)
- [UV Package Manager](https://github.com/astral-sh/uv)
- [dbt Documentation](https://docs.getdbt.com/)

---

## ✅ Checklist

- [ ] GCP authentication complete
- [ ] BigQuery dataset `nytaxi` created
- [ ] GCS bucket `dtc-decourse-dbt-nytaxi` created
- [ ] UV installed
- [ ] 48 CSV files uploaded to GCS
- [ ] External tables created in BigQuery
- [ ] Native tables created and partitioned
- [ ] Verification queries run successfully
- [ ] Sample data queries tested

---

**Setup Complete!** 🎉

You now have green and yellow taxi data for 2019-2020 ready for analytics engineering work.
