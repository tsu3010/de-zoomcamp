-- ============================================================================
-- Create BigQuery Tables from GCS Files
-- Project: dtc-de-course-486009
-- Dataset: nytaxi
-- ============================================================================

-- ============================================================================
-- 1. GREEN TAXI DATA
-- ============================================================================

-- Create external table for green taxi (points to GCS files)
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
    format = 'CSV',
    uris = ['gs://dtc-decourse-dbt-nytaxi/green_tripdata_*.csv'],
    skip_leading_rows = 1
);

-- Create native partitioned table for green taxi
CREATE OR REPLACE TABLE `dtc-de-course-486009.nytaxi.greentrip_data`
PARTITION BY DATE(lpep_pickup_datetime)
AS
SELECT
    -- Generate unique row ID
    MD5(CONCAT(
        COALESCE(CAST(VendorID AS STRING), ''),
        COALESCE(CAST(lpep_pickup_datetime AS STRING), ''),
        COALESCE(CAST(lpep_dropoff_datetime AS STRING), ''),
        COALESCE(CAST(PULocationID AS STRING), ''),
        COALESCE(CAST(DOLocationID AS STRING), '')
    )) AS unique_row_id,

    -- All original columns
    VendorID,
    lpep_pickup_datetime,
    lpep_dropoff_datetime,
    store_and_fwd_flag,
    RatecodeID,
    PULocationID,
    DOLocationID,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    ehail_fee,
    improvement_surcharge,
    total_amount,
    payment_type,
    trip_type,
    congestion_surcharge
FROM `dtc-de-course-486009.nytaxi.green_tripdata_external`
WHERE lpep_pickup_datetime IS NOT NULL;


-- ============================================================================
-- 2. YELLOW TAXI DATA
-- ============================================================================

-- Create external table for yellow taxi (points to GCS files)
CREATE OR REPLACE EXTERNAL TABLE `dtc-de-course-486009.nytaxi.yellow_tripdata_external`
(
    VendorID STRING,
    tpep_pickup_datetime TIMESTAMP,
    tpep_dropoff_datetime TIMESTAMP,
    passenger_count INT64,
    trip_distance NUMERIC,
    RatecodeID STRING,
    store_and_fwd_flag STRING,
    PULocationID STRING,
    DOLocationID STRING,
    payment_type INT64,
    fare_amount NUMERIC,
    extra NUMERIC,
    mta_tax NUMERIC,
    tip_amount NUMERIC,
    tolls_amount NUMERIC,
    improvement_surcharge NUMERIC,
    total_amount NUMERIC,
    congestion_surcharge NUMERIC
)
OPTIONS (
    format = 'CSV',
    uris = ['gs://dtc-decourse-dbt-nytaxi/yellow_tripdata_*.csv'],
    skip_leading_rows = 1
);

-- Create native partitioned table for yellow taxi
CREATE OR REPLACE TABLE `dtc-de-course-486009.nytaxi.yellowtrip_data`
PARTITION BY DATE(tpep_pickup_datetime)
AS
SELECT
    -- Generate unique row ID
    MD5(CONCAT(
        COALESCE(CAST(VendorID AS STRING), ''),
        COALESCE(CAST(tpep_pickup_datetime AS STRING), ''),
        COALESCE(CAST(tpep_dropoff_datetime AS STRING), ''),
        COALESCE(CAST(PULocationID AS STRING), ''),
        COALESCE(CAST(DOLocationID AS STRING), '')
    )) AS unique_row_id,

    -- All original columns
    VendorID,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    RatecodeID,
    store_and_fwd_flag,
    PULocationID,
    DOLocationID,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge
FROM `dtc-de-course-486009.nytaxi.yellow_tripdata_external`
WHERE tpep_pickup_datetime IS NOT NULL;


-- ============================================================================
-- 3. VERIFY DATA
-- ============================================================================

-- Check row counts
SELECT 'Green Taxi External' AS table_name, COUNT(*) AS row_count
FROM `dtc-de-course-486009.nytaxi.green_tripdata_external`
UNION ALL
SELECT 'Green Taxi Native', COUNT(*)
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
UNION ALL
SELECT 'Yellow Taxi External', COUNT(*)
FROM `dtc-de-course-486009.nytaxi.yellow_tripdata_external`
UNION ALL
SELECT 'Yellow Taxi Native', COUNT(*)
FROM `dtc-de-course-486009.nytaxi.yellowtrip_data`;

-- Check date ranges
SELECT
    'Green Taxi' AS taxi_type,
    MIN(DATE(lpep_pickup_datetime)) AS min_date,
    MAX(DATE(lpep_pickup_datetime)) AS max_date,
    COUNT(DISTINCT DATE(lpep_pickup_datetime)) AS distinct_days
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
UNION ALL
SELECT
    'Yellow Taxi',
    MIN(DATE(tpep_pickup_datetime)),
    MAX(DATE(tpep_pickup_datetime)),
    COUNT(DISTINCT DATE(tpep_pickup_datetime))
FROM `dtc-de-course-486009.nytaxi.yellowtrip_data`;

-- Sample data from both tables
SELECT 'Green Taxi Sample' AS description, *
FROM `dtc-de-course-486009.nytaxi.greentrip_data`
LIMIT 5;

SELECT 'Yellow Taxi Sample' AS description, *
FROM `dtc-de-course-486009.nytaxi.yellowtrip_data`
LIMIT 5;
