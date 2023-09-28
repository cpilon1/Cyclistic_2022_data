-- The number of docked bikes in individual tables and aggregated table is equal. --

SELECT
  (SELECT COUNT (*)
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
  rideable_type = "docked_bike") 
  +
  (SELECT COUNT (*)
  FROM `first-project-394620.Cyclistic_2022.data_02`
  WHERE
  rideable_type = "docked_bike")
  +
  ...
  ...
  +
  (SELECT COUNT (*)
  FROM `first-project-394620.Cyclistic_2022.data_12`
  WHERE
  rideable_type = "docked_bike")
  ,
  (SELECT COUNT(*) AS aggregated
  FROM
  first-project-394620.Cyclistic_2022.data_aggregated
  WHERE
  rideable_type = "docked_bike");


-- The number of rides < 1 minute and longer than 24 hours is the same in individual tables and aggregated data. --
SELECT
  (SELECT COUNT (*)
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
  DATETIME_DIFF(ended_at, started_at, minute) <1 OR
  DATETIME_DIFF(ended_at, started_at, minute) >= 1440)
+
  (SELECT COUNT (*)
  FROM `first-project-394620.Cyclistic_2022.data_02`
  WHERE
  DATETIME_DIFF(ended_at, started_at, minute) <1 OR
  DATETIME_DIFF(ended_at, started_at, minute) >= 1440)
+
...
...
+
  (SELECT COUNT (*)
  FROM `first-project-394620.Cyclistic_2022.data_12`
  WHERE
  DATETIME_DIFF(ended_at, started_at, minute) <1 OR
  DATETIME_DIFF(ended_at, started_at, minute) >= 1440)
,
  (SELECT COUNT (*)
  FROM `first-project-394620.Cyclistic_2022.data_aggregated`
  WHERE
  DATETIME_DIFF(ended_at, started_at, minute) <1 OR
  DATETIME_DIFF(ended_at, started_at, minute) >= 1440);


-- The number of NULL start_station_names and end_station_names is the same in individual tables and aggregated data. --
SELECT
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
start_station_name IS NULL OR end_station_name IS NULL) 
+
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_02`
WHERE
start_station_name IS NULL OR end_station_name IS NULL) 
+
...
...
+
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_12`
WHERE
start_station_name IS NULL OR end_station_name IS NULL)
,
(SELECT COUNT(*) AS aggregated
FROM
first-project-394620.Cyclistic_2022.data_aggregated
WHERE
start_station_name IS NULL OR end_station_name IS NULL);



-- The totals of  (# trips of tables - dirty data) = (aggregated - dirty data) = cleaned data 
SELECT
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
rideable_type <> "docked_bike" AND
start_station_name IS NOT NULL AND
end_station_name IS NOT NULL AND
DATETIME_DIFF(ended_at, started_at, minute) >=1 AND
DATETIME_DIFF(ended_at, started_at, minute) < 1440)
+
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_02`
WHERE
rideable_type <> "docked_bike" AND
start_station_name IS NOT NULL AND
end_station_name IS NOT NULL AND
DATETIME_DIFF(ended_at, started_at, minute) >=1 AND
DATETIME_DIFF(ended_at, started_at, minute) < 1440)
+
...
...
+
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_12`
WHERE
rideable_type <> "docked_bike" AND
start_station_name IS NOT NULL AND
end_station_name IS NOT NULL AND
DATETIME_DIFF(ended_at, started_at, minute) >=1 AND
DATETIME_DIFF(ended_at, started_at, minute) < 1440)
,  
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_aggregated`
WHERE
rideable_type <> "docked_bike" AND
start_station_name IS NOT NULL AND
end_station_name IS NOT NULL AND
DATETIME_DIFF(ended_at, started_at, minute) >=1 AND
DATETIME_DIFF(ended_at, started_at, minute) < 1440)
,
(SELECT COUNT (*)
FROM `first-project-394620.Cyclistic_2022.data_cleaned`);

-- Prove that eliminated data + non-eliminated data = original data --
SELECT
  (SELECT COUNT(*) -- eliminated by bike only --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
    ((DATETIME_DIFF(ended_at, started_at, minute) >=1) AND
    (DATETIME_DIFF(ended_at, started_at, minute) < 1440)) AND
    (rideable_type = "docked_bike") AND
    (start_station_name IS NOT NULL AND end_station_name IS NOT NULL)) AS elim_by_b,
  
  (SELECT COUNT (*) -- eliminated by time --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
    ((DATETIME_DIFF(ended_at, started_at, minute) < 1) OR
    (DATETIME_DIFF(ended_at, started_at, minute) >= 1440)) AND
    (rideable_type <> "docked_bike") AND
    (start_station_name IS NOT NULL AND end_station_name IS NOT NULL)) AS elim_by_t,
  
  (SELECT COUNT(*) -- eliminated by station only --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
    ((DATETIME_DIFF(ended_at, started_at, minute) >=1) AND
    (DATETIME_DIFF(ended_at, started_at, minute) < 1440)) AND
    (rideable_type <> "docked_bike") AND
    (start_station_name IS NULL OR end_station_name IS NULL)) AS elim_by_s,
  
  (SELECT COUNT (*) -- eliminated by bike and station --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
    ((DATETIME_DIFF(ended_at, started_at, minute) >= 1) AND
    (DATETIME_DIFF(ended_at, started_at, minute) < 1440)) AND
    (rideable_type = "docked_bike") AND
    (start_station_name IS NULL OR end_station_name IS NULL)) AS elim_by_bs,
  
  (SELECT COUNT (*) -- eliminated by time and station --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
    ((DATETIME_DIFF(ended_at, started_at, minute) < 1) OR
    (DATETIME_DIFF(ended_at, started_at, minute) >= 1440)) AND
    (rideable_type <> "docked_bike") AND
    (start_station_name IS NULL OR end_station_name IS NULL)) AS elim_by_ts,
  
  (SELECT COUNT (*) -- eliminated by bike and time --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
    ((DATETIME_DIFF(ended_at, started_at, minute) < 1) OR
    (DATETIME_DIFF(ended_at, started_at, minute) >= 1440)) AND
    (rideable_type = "docked_bike") AND
    (start_station_name IS NOT NULL AND end_station_name IS NOT NULL)) AS elim_by_bt,
  
  (SELECT COUNT (*) -- eliminated by bike, time and station --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
    ((DATETIME_DIFF(ended_at, started_at, minute) < 1) OR
    (DATETIME_DIFF(ended_at, started_at, minute) >= 1440)) AND
    (rideable_type = "docked_bike") AND
    (start_station_name IS NULL OR end_station_name IS NULL)) AS elim_by_bts,
  
  (SELECT COUNT(*) -- eliminated by bike only --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
  ((DATETIME_DIFF(ended_at, started_at, minute) >=1) AND
  (DATETIME_DIFF(ended_at, started_at, minute) < 1440)) AND
  (rideable_type = "docked_bike") AND
  (start_station_name IS NOT NULL AND end_station_name IS NOT NULL) ) +
  
  (SELECT COUNT (*) -- eliminated by time only --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
  ((DATETIME_DIFF(ended_at, started_at, minute) < 1) OR
  (DATETIME_DIFF(ended_at, started_at, minute) >= 1440)) AND
  (rideable_type <> "docked_bike") AND
  (start_station_name IS NOT NULL AND end_station_name IS NOT NULL)) +
  
  (SELECT COUNT(*) -- eliminated by station only --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
  ((DATETIME_DIFF(ended_at, started_at, minute) >=1) AND
  (DATETIME_DIFF(ended_at, started_at, minute) < 1440)) AND
  (rideable_type <> "docked_bike") AND
  (start_station_name IS NULL OR end_station_name IS NULL)) +
  
    (SELECT COUNT (*) -- eliminated by bike and station --
  FROM `first-project-394620.Cyclistic_2022.data_01`
  WHERE
  ((DATETIME_DIFF(ended_at, started_at, minute) >= 1) AND
  (DATETIME_DIFF(ended_at, started_at, minute) < 1440)) AND
  (rideable_type = "docked_bike") AND
  (start_station_name IS NULL OR end_station_name IS NULL)) +

  (SELECT COUNT (*) -- eliminated by time and station --
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
((DATETIME_DIFF(ended_at, started_at, minute) < 1) OR
(DATETIME_DIFF(ended_at, started_at, minute) >= 1440)) AND
(rideable_type <> "docked_bike") AND
(start_station_name IS NULL OR end_station_name IS NULL)) +

  (SELECT COUNT (*) -- eliminated by bike, time and station --
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
((DATETIME_DIFF(ended_at, started_at, minute) < 1) OR
(DATETIME_DIFF(ended_at, started_at, minute) >= 1440)) AND
(rideable_type = "docked_bike") AND
(start_station_name IS NULL OR end_station_name IS NULL)) AS all_elim,

(SELECT COUNT(*) -- none eliminated --
FROM `first-project-394620.Cyclistic_2022.data_01`
WHERE
((DATETIME_DIFF(ended_at, started_at, minute) >=1) AND
(DATETIME_DIFF(ended_at, started_at, minute) < 1440)) AND
(rideable_type <> "docked_bike") AND
(start_station_name IS NOT NULL AND end_station_name IS NOT NULL)) AS no_elim,

(SELECT COUNT (*) -- original trips --
FROM `first-project-394620.Cyclistic_2022.data_01`
) AS all_trips

