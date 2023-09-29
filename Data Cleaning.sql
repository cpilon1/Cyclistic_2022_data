-- Create a table and: remove docked bikes, trip duration in minutes, trip duration in month, day of week, time, exclude start/end station nulls, exclude lat/lng --

CREATE TABLE first-project-394620.Cyclistic_2022.data_cleaned AS
SELECT
ride_id,
rideable_type,
EXTRACT(DATE FROM started_at) AS startdate,
EXTRACT(DAYOFWEEK FROM started_at) AS startday,
EXTRACT(DAYOFWEEK FROM ended_at) AS endday,
EXTRACT(TIME FROM started_at) AS starttime,
EXTRACT(TIME FROM ended_at) AS endtime,
DATETIME_DIFF(ended_at, started_at, MINUTE) AS duration_min,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
member_casual
FROM `first-project-394620.Cyclistic_2022.data_aggregated`
WHERE
(DATETIME_DIFF(ended_at, started_at, minute) >=1) AND
(DATETIME_DIFF(ended_at, started_at, minute) < 1440) AND
(rideable_type <> "docked_bike") AND
(start_station_name IS NOT NULL AND end_station_name IS NOT NULL)
ORDER BY startdate, starttime
