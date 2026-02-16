# Data Engineering Zoomcamp 2026: Week 4 - Analytics Engineering

This repository contains my solutions for the **Module 4: Analytics Engineering** homework. The project demonstrates how to transform raw taxi trip data into analytics-ready models using **dbt** and **BigQuery**.

---

## 🛠️ Environment Configuration
* **GCP Project ID:** `dtc-de-course-486009`
* **Dataset ID:** `dbt_sthyagaraj`
* **Data Warehouse:** Google BigQuery
* **Transformation Tool:** dbt (Cloud/Core)

---

## 📂 Model Architecture
I followed the dbt best practices for a modular data pipeline:
* **Staging (`stg_`)**: Cleaning, renaming, and type casting.
* **Intermediate (`int_`)**: Logic for unioning Yellow and Green taxi data.
* **Fact (`fct_`)**: Final tables used for BI and reporting.

---

## 📝 Homework Solutions

### Question 1: dbt Lineage and Execution
**Question:** `dbt run --select int_trips_unioned` builds which models?
* **Answer:** `stg_green_tripdata, stg_yellow_tripdata, and int_trips_unioned` only 

### Question 2: dbt Tests
**Question:** If a value `6` appears in `payment_type` (which expects 1-5), what happens during `dbt test`?
* **Answer:** dbt will fail the test and return a non-zero exit code.

### Question 3: Counting Records in `fct_monthly_zone_revenue`
**Question:** What is the count of records in the `fct_monthly_zone_revenue` model?
* **Answer:** **12,998**
* **Validation Query:**
    ```sql
    SELECT count(1) 
    FROM `dtc-de-course-486009.dbt_sthyagaraj.fct_monthly_zone_revenue`;
    ```

### Question 4: Best Performing Zone for Green Taxis (2020)
**Question:** Which pickup zone had the highest total revenue for Green taxi trips in 2020?
* **Answer:** **East Harlem North**
* **Validation Query:**
    ```sql
    SELECT 
        pickup_zone, 
        SUM(revenue_monthly_total_amount) as total_rev
    FROM `dtc-de-course-486009.dbt_sthyagaraj.fct_monthly_zone_revenue`
    WHERE taxi_type = 'Green' AND year = 2020
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1;
    ```

### Question 5: Green Taxi Trip Counts (October 2019)
**Question:** What is the total number of trips for Green taxis in October 2019?
* **Answer:** **384,624**

### Question 6: FHV Staging Model
**Question:** What is the count of records in `stg_fhv_tripdata` after filtering out NULL `dispatching_base_num`?
* **Answer:** **22998722**

---

## 🚀 How to Run
To replicate these results:

1.  **Install dependencies:**
    ```bash
    dbt deps
    ```
2.  **Seed the Taxi Zones lookup table:**
    ```bash
    dbt seed
    ```
3.  **Run the models (Production Mode):**
    ```bash
    dbt run --target prod --var 'is_test_run: false'
    ```
4.  **Execute tests:**
    ```bash
    dbt test
    ```

---
