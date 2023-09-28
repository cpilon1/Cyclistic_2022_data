-- Aggregate Tables data_01, data_02... data_12 --

CREATE TABLE data_aggregated AS

SELECT *
FROM `first-project-394620.Cyclistic_2022.data_01`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_02`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_03`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_04`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_05`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_06`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_07`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_08`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_09`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_10`
UNION ALL
SELECT *
FROM `first-project-394620.Cyclistic_2022.data_11`
UNION ALL
SELECT*
FROM `first-project-394620.Cyclistic_2022.data_12`

-- Create a table of station name and average latitude and longitude. -- 
CREATE TABLE first-project-394620.Cyclistic_2022.station_coords1 AS
SELECT
start_station_name,
ROUND(AVG(start_lat),3) AS station_lat,
ROUND(AVG(start_lng),3) AS station_lng
FROM `first-project-394620.Cyclistic_2022.data_aggregated`
WHERE
start_lng IS NOT NULL AND start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY start_station_name
