
# Data Engineering Zoomcamp 2026: Homework 2 Solutions

## Question 1: Uncompressed File Size

Answer: 128.3 MiBLogic: I ran the Yellow Taxi flow for 2020-12. After the extract task completed, I checked the Outputs tab in Kestra. The size attribute for the uncompressed .csv file recorded 134.5 MB, which converts to approximately $128.3$ MiB.

## Question 2: Rendered Value of file Variable
Answer: {{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv

Logic: In Kestra, variables defined in the inputs section are accessed using the double curly-brace syntax. To construct the filename dynamically, we concatenate the taxi type, year, and month strings.

## Question 3: Yellow Taxi 2020 Row Count
Answer: 24,648,499

Logic: I triggered a Backfill for the Yellow taxi flow spanning 2020-01-01 to 2020-12-01. Once complete, I ran a COUNT(*) query in BigQuery:

```
SELECT count(*) FROM `trips_data_all.yellow_tripdata` 
WHERE filename LIKE 'yellow_tripdata_2020%';
```


## Question 4: Green Taxi 2020 Row Count
Answer: 1,734,051

Logic: Using the same logic as Q3, I ran the Backfill for Green taxi data for the year 2020 and queried the resulting table in BigQuery.

## Question 5: Yellow Taxi March 2021 Row Count
Answer: 1,925,152

Logic: I executed the flow manually with inputs taxi: yellow, year: 2021, and month: 03. The execution logs confirmed the number of rows processed and inserted into the table

## Question 6: Schedule Trigger Timezone
Answer: Add a timezone property set to America/New_York

Logic: To ensure the flow runs according to the local time in New York (where the data originates), the timezone property must be explicitly defined within the Schedule trigger block in the YAML configuration.



