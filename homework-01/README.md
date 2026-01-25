

## Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.
What's the version of `pip` in the image?

```
docker run -it --rm python:3.13 bash
pip --version
```

Answer: 25.3

## Question 2. Understanding Docker networking and docker-compose

Answer: db:5432

## Question 3. Counting short trips
```
SELECT 
COUNT(1) AS no_trips_1mileandbelow
FROM 
green_taxi_data 
WHERE 1=1
AND lpep_pickup_datetime >= '2025-11-01' 
AND lpep_pickup_datetime < '2025-12-01'
AND trip_distance <= 1
```
Answer: 8007

## Question 4. Longest trip for each day
```
SELECT 
DATE(lpep_pickup_datetime) AS pickup_date,
MAX(trip_distance) AS longest_trip
FROM 
green_taxi_data 
WHERE 1=1
AND trip_distance < 100 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
```
Answer : 2025-11-14

## Question 5. Biggest pickup zone
```
SELECT 
    z."Zone" AS pickup_zone,
    SUM(t.trip_distance) AS total_distance
FROM 
    green_taxi_data t
JOIN 
    zones z ON t."PULocationID" = z."LocationID"
WHERE 
    DATE(t.lpep_pickup_datetime) = '2025-11-18'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
```

Answer: East Harlem North

## Question 6. Largest tip
```
SELECT 
    zdo."Zone" AS dropoff_zone,
    MAX(t.tip_amount) AS largest_tip
FROM 
    green_taxi_data t
JOIN 
    zones zpu ON t."PULocationID" = zpu."LocationID"
JOIN 
    zones zdo ON t."DOLocationID" = zdo."LocationID"
WHERE 
    zpu."Zone" = 'East Harlem North'
    AND DATE(t.lpep_pickup_datetime) >= '2025-11-01'
    AND DATE(t.lpep_pickup_datetime) < '2025-12-01'
GROUP BY 
    dropoff_zone
ORDER BY 
    largest_tip DESC
LIMIT 1;
```

Answer: Yorkville West

## Question 7. Terraform Workflow