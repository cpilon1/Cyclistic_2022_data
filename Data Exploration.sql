-- For each table I used the following script. --

-- 1. Each file has uploaded to BigQuery successfully. --
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_01`
LIMIT 20;

-- 2. There are no duplciate values for ride_id. -- 
SELECT
COUNT(ride_id) AS num_ride_ids,
COUNT (DISTINCT ride_id) AS distinct_ride_ids
FROM `first-project-394620.Cyclistic_2022.data_01`;

-- 3. There exists null values in start_station_name, start_station_id, end_station_name, end_station_id, end_lat, and end_lng. -- 
SELECT
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE ride_id is NULL) AS ride_id,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE rideable_type is NULL) AS rideable_type,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE started_at is NULL) AS started_at,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE ended_at is NULL) AS ended_at,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE start_station_name is NULL) AS start_station_name,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE start_station_id is NULL) AS start_station_id,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE end_station_name is NULL) AS end_station_name,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE end_station_id is NULL) AS end_station_id,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE start_lat is NULL) AS start_lat,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE start_lng is NULL) AS start_lng,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE end_lat is NULL) AS end_lat,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE end_lng is NULL) AS end_lng,
(SELECT COUNT(*) FROM `first-project-394620.Cyclistic_2022.data_12` WHERE member_casual is NULL) AS member_casual;

-- 4. There does not exist rows where start_station_name/end_station_name and corresponding start_station_id/end_station_id are null. --
SELECT
DISTINCT start_station_name,
start_station_id,
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
(start_station_name IS NOT NULL AND start_station_id IS NULL) OR
(start_station_name IS NULL AND start_station_id IS NOT NULL);

SELECT
DISTINCT end_station_name,
end_station_id,
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
(end_station_name IS NOT NULL AND end_station_id IS NULL) OR
(end_station_name IS NULL AND end_station_id IS NOT NULL);

-- 5. There exists rows where both start_station_name and end_station_name are null. NOTE: Filter those rows out. --
SELECT
COUNT(ride_id)
FROM `first-project-394620.Cyclistic_2022.data_12`
WHERE
(start_station_name IS NULL AND end_station_name IS NULL);

-- 6. Where the end_lat and end_lng values are null, the station name is not null. NOTE: Keep those rows. -- 
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
end_lng IS NULL
ORDER BY end_station_name;

-- 7. Where the start_station_name/end_station_name is null, there are non-null start_lat, start_lng, end_lat and end_lng values. --
SELECT
COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
(start_station_name IS NULL AND
start_lat IS NOT NULL AND start_lng IS NOT NULL) OR
(end_station_name IS NULL AND
end_lat IS NOT NULL AND end_lng IS NOT NULL);

-- 8. For each station name, there are differing values of start_lat and start_lng and end_lat and end_lng. --
SELECT
DISTINCT start_station_name,
start_lat,
start_lng
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE start_station_name IS NOT NULL
ORDER BY start_station_name;

-- 9. Standardize lat/lng for each station name by averaging then rounding to 4 decimal places. --
SELECT
start_station_name,
ROUND(AVG(start_lat),4) AS start_lat_rnd,
ROUND(AVG(start_lng),4) AS start_lng_rnd
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
start_lng IS NOT NULL AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY start_lat_rnd, start_lng_rnd;

-- 10. The lat/lng values are not directly related to station names, and therefore cannot be used to identify null station names. When comparing the average, rounded lat/lng for each station in different tables, there is variation in lat/lng at the hundredths and thousandths places. --  
SELECT
data_10.start_station_name,
ROUND(AVG(data_01.start_lat),4) AS data_01_lat,
ROUND(AVG(data_10.start_lat),4) AS data_10_lat,
ROUND(AVG(data_01.start_lng),4) AS data_01_lng,
ROUND(AVG(data_10.start_lng),4) AS data_10_lng,
FROM
first-project-394620.Cyclistic_2022.data_01
INNER JOIN
first-project-394620.Cyclistic_2022.data_10
ON data_01.start_station_name = data_10.start_station_name
GROUP BY start_station_name
ORDER BY data_01_lat, data_10_lat

-- 11. There are trips less than 1 minute long and longer than 24 hours. NOTE: Omit these trips. --
SELECT
COUNT(*) AS minute_or_less
FROM first-project-394620.Cyclistic_2022.data_01
WHERE
DATETIME_DIFF(DATETIME (ended_at), DATETIME (started_at), MINUTE) <= 1;
SELECT
COUNT(*) AS more_than_a_day
FROM first-project-394620.Cyclistic_2022.data_01
WHERE
DATETIME_DIFF(DATETIME (ended_at), DATETIME (started_at), MINUTE) >= 1440;

-- 12. There are entries with docked bikes. NOTE: Omit these trips. --
SELECT
COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
rideable_type = "docked_bike"

-- 13. There are no spelling errors or extra spaces in rideable_type or member_type. --
SELECT
DISTINCT (rideable_type)
FROM `first-project-394620.Cyclistic_2022.data_01`;

SELECT
DISTINCT (member_casual)
FROM `first-project-394620.Cyclistic_2022.data_01`;

-- 14. The string length for station names varies between 10-53 characters. Upon examining short and long string lengths, there were no field errors. --
SELECT
MIN (LENGTH(start_station_name)) AS min_length_start,
MAX (LENGTH(start_station_name)) AS max_length_start,
MIN (LENGTH(end_station_name)) AS min_length_end,
Max (LENGTH(end_station_name)) AS max_length_end
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
start_station_name IS NOT NULL AND end_station_name IS NOT NULL; 

SELECT
start_station_name,
end_station_name,
LENGTH(start_station_name) < 10 AS start_station_less_than_10,
LENGTH(start_station_name) > 53 AS start_station_greater_than_53,
LENGTH(end_station_name) < 10 AS end_station_less_than_10,
LENGTH(end_station_name) > 53 AS end_station_greater_than_53,
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
(LENGTH(start_station_name) <10 OR
LENGTH(start_station_name) > 53 OR
LENGTH(end_station_name) < 10 OR
LENGTH(end_station_name) > 53 ) AND
(start_station_name IS NOT NULL AND end_station_name IS NOT NULL);
