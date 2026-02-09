## Data Engineering Zoomcamp 2026 - Week 3 Homework
Infrastructure Overview
GCP Project ID: dtc-de-course-486009
GCS Bucket Name: dtc-de-course-486009-kestra-bucket
BigQuery Dataset: zoomcamp

Workflow Orchestrator: Kestra

### Dataset Setup
The dataset used for this homework is the 2024 Yellow Taxi Trip Records (Parquet format). The data was ingested via Kestra, uploaded to GCS, and then used to create both an External and a Materialized table in BigQuery.

SQL Setup Commands
External Table:
## SQL
```sql
CREATE OR REPLACE EXTERNAL TABLE `dtc-de-course-486009.zoomcamp.external_yellow_tripdata_2024`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dtc-de-course-486009-kestra-bucket/yellow_tripdata_2024/*.parquet']
);
```

Materialized (Native) Table:
## SQL
```sql
CREATE OR REPLACE TABLE `dtc-de-course-486009.zoomcamp.yellow_tripdata_2024` AS
SELECT * FROM `dtc-de-course-486009.zoomcamp.external_yellow_tripdata_2024`;
```

## Homework Questions & Solutions

## Question 1 
What is count of records for the 2024 Yellow Taxi Data?
Answer: 20,332,093

Query: SELECT count(*) FROM dtc-de-course-486009.zoomcamp.yellow_tripdata_2024;

## Question 2
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables. What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
Answer: 0 MB for the External Table and 155.12 MB for the Materialized Table

## Question 3
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. Now write a query to retrieve the PULocationID and DOLocationID from the same table. Why are the estimated number of Bytes different?
Answer: BigQuery is a columnar database, and it only scans the specific columns requested in the query.

## Question 4 
How many records have a fare_amount of 0?
Answer: 8,333

Query: SELECT count(*) FROM dtc-de-course-486009.zoomcamp.yellow_tripdata_2024 WHERE fare_amount = 0;

## Question 5 
What is the best strategy to make an optimized table in BigQuery if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID?
Answer: Partition by tpep_dropoff_datetime and Cluster on VendorID

## Question 6: 
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive). Use the materialized table you created earlier in first part of the homework and the partitioned table. What is the estimated bytes to be read?

Answer: 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

## Question 7  
Where is the data stored in the External Table?
Answer: GCP Bucket

## Question 8 
It is best practice in BigQuery to always cluster your data:
Answer: False (Clustering is not beneficial for small tables or if query patterns do not match clustered columns).

## Question 9
Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?

Answer: 0 bytes. BigQuery stores the row count in the table's metadata.