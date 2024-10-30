# Exercise 1

SELECT sum(salary) FROM employees;

## ┌─────────────┐
## │ sum(salary) │
## │   double    │
## ├─────────────┤
## │    236000.0 │
## └─────────────┘

SELECT round(avg(salary),2) AS avg_salary, dept 
  FROM employees GROUP BY dept;

## ┌────────────┬────────────┐
## │ avg_salary │    dept    │
## │   double   │  varchar   │
## ├────────────┼────────────┤
## │    37000.0 │ Sales      │
## │   41666.67 │ Accounting │
## └────────────┴────────────┘

# Exercise 2

SELECT *, round(salary - avg_salary,2) AS abv_avg FROM employees 
NATURAL LEFT JOIN (
  SELECT round(avg(salary),2) AS avg_salary, dept 
    FROM employees GROUP BY dept
) ORDER BY dept, abv_avg;

# Exercise 3

SELECT sum(seats) FROM flights NATURAL LEFT JOIN planes; # Wrong

SELECT sum(seats) FROM flights LEFT JOIN planes USING (tailnum); # Correct




# Demo

DESCRIBE SELECT * FROM read_parquet("yellow_*.parquet");

SELECT count(*) FROM read_parquet("yellow_*.parquet");


SELECT avg(tip_amount / total_amount) 
  FROM read_parquet("yellow_*.parquet") 
  WHERE total_amount > 0 AND tip_amount >= 0;

SELECT avg(tip_amount / total_amount), payment_type
  FROM read_parquet("yellow_*.parquet") 
  WHERE total_amount > 0 AND tip_amount >= 0
  GROUP BY payment_type
  ORDER BY payment_type;


SELECT * FROM (
  SELECT
    PULocationID pickup_zone,
    AVG(fare_amount / trip_distance) fare_per_mile,
    COUNT(*) num_rides
  FROM read_parquet("yellow_*.parquet")
  WHERE trip_distance > 0
  GROUP BY PULocationID
) NATURAL LEFT JOIN (
  SELECT LocationID pickup_zone, * FROM 
  read_csv("https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv")
) ORDER BY pickup_zone;
