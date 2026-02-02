

-- Q3: Yellow Taxi 2020 Total Rows
SELECT COUNT(*) 
FROM `dtc-de-course-486009.zoomcamp.yellow_tripdata`
WHERE filename LIKE 'yellow_tripdata_2020%';

-- Q4: Green Taxi 2020 Total Rows
SELECT COUNT(*) 
FROM `dtc-de-course-486009.zoomcamp.green_tripdata`
WHERE filename LIKE 'green_tripdata_2020%';

-- Q5: Yellow Taxi March 2021 Total Rows
SELECT COUNT(*) 
FROM `dtc-de-course-486009.zoomcamp.yellow_tripdata`
WHERE filename = 'yellow_tripdata_2021-03.csv';