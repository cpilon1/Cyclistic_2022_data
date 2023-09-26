Cyclistic_2022_data
Cyclistic bikeshare data has been cleaned and aggregated using SQL and analysis visualized using Tableau. 

# Introduction
In the following case study, I will perform the real-world tasks of a junior data analyst for a fictitious bike-sharing company. To answer the business questions, I will follow the steps of the data analysis process: Ask, Prepare, Process, Analyze, Share, and Act.

## Background
Cyclistic is a bike-share company founded in 2016 in Chicago, Illinois. The company has more than 5,800 bicycles and 600 docking stations in the Chicago metropolitan area. Besides traditional bicycles and e-bikes, Cyclistic offers reclining bikes, hand tricycles and cargo bikes to make bike-sharing more inclusive to people with disabilities. The pricing plans offered are single-ride passes, full-day passes, and annual memberships.

# Ask
Cyclistic’s finance analysts have determined that annual memberships are more profitable than single-ride and day-passes. Cyclistic marketing director Lily Moreno believes converting casual riders into annual members is the best way to ensure the company’s growth. 

The goal of Moreno’s marketing team is to design strategies to convert casual users into annual members by determining 1) how casual users and annual members use Cyclistic bikes differently, 2) why casual riders would buy Cyclistic annual memberships, and 3) How Cyclistic can use digital media to influence casual riders to become members.

## Task
Moreno has assigned me the task of answering 1) How casual users and annual members use Cyclistic bikes differently. 

# Prepare
## Data Source
The data used is Cyclistic historical trip data for the year 2022. The data is split up into 12 files, one for each month of the year. The data is organized by each Cyclistic trip taken and consists of a unique trip Ride ID, the type of bike used, when and where the individual trip started and ended, the geographic coordinates of the start and end location, and the user type. 

| Data Source | Cyclistic trip data 2022 |
| ----------- | ------------------------ |
| File Type | .csv files |
| Number of files | 12 |
| Data elements |<li>Ride ID (unique identifier for each ride)</li><li>Bike type (electric, regular or docked)</li><li>Trip start and end time and date</li><li>Trip start station and start station ID</li><li>Trip end station and end station ID</li><li>Trip start and end geographic coordinates</li><li>User type (annual member or casual user)</li>|

The files are publicly available at the following [index](https://divvy-tripdata.s3.amazonaws.com/index.html) and made available by Motivate International Inc. under [this license](https://divvybikes.com/data-license-agreement). Due to data-privacy regulations, riders’ personally identifiable information and payment information is not available.

The data files were uploaded to Google Cloud Services with public access prevention and Google-managed data encryption, and were also backed up to an external hard drive.

Data Files
| File Name |Database Table Name |Number of Rows|
| ----------- | ------------ | ---------------|
|202201-divvy-tripdata.csv | data_01 | 103,770 |
|202202-divvy-tripdata.csv |data_02|115,609|
|202203-divvy-tripdata.csv|data_03|284,042|
|202204-divvy-tripdata.csv|data_04|371,249|
|202205-divvy-tripdata.csv|data_05|634,858|
|202206-divvy-tripdata.csv|data_06|769,204|
|202207-divvy-tripdata.csv|data_07|823,488|
|202208-divvy-tripdata.csv|data_08|785,932|
|202209-divvy-publictripdata.csv|data_09|701,339|
|202210-divvy-tripdata.csv|data_10|558,685|
|202211-divvy-tripdata.csv|data_11|337,735|
|202212-divvy-tripdata.csv|data_12|181,806|

# Process
Due to the large amount of data, the [BigQuery SQL database platform](https://cloud.google.com/bigquery?utm_source=google&utm_medium=cpc&utm_campaign=na-none-all-en-dr-sitelink-all-all-trial-e-gcp-1605212&utm_content=text-ad-none-any-DEV_c-CRE_665665924750-ADGP_Hybrid+%7C+BKWS+-+MIX+%7C+Txt_BigQuery-KWID_43700077225652815-kwd-47616965283-userloc_9067609&utm_term=KW_bigquery-ST_bigquery-NET_g-&gclid=EAIaIQobChMIisiHto7JgQMVwfnICh2UmAfuEAAYASABEgJbSPD_BwE&gclsrc=aw.ds) was used to explore and clean the data. The following steps were taken to view, sort and filter the data.

## Explore the Data
To explore the data, the following measures were taken. 
1. Query each table to make sure it has imported correctly into BigQuery.
   - Result: All tables imported correctly.
3. Examine table schemas to ensure uniformity across tables.
   - Result: All tables have the same schema.
4. Check for duplicate Ride IDs.
	- Result: There were no duplicate Ride IDs.
5. Examine nulls in all fields.
	- Result: There were nulls in start and end station names. When the station name was null, the station ID was also null.
		- Action: Determine possibility of using provided station coordinates to fill in the missing start and end station names. 
Start by listing the latitude and longitude for each station name, rounded to .001. The station latitude and longitude vary by entry; for example, Aberdeen St & Monroe St has latitude values of 41.881 and 41.88 and longitude values of -87.656 and -87.655 in Rows 7 and 8, respectively. Therefore, the station coordinates have variance. Furthermore, the close proximity of stations to one another makes it so that multiple stations have the same or similar coordinates; the nearby station Ada St & 113th St in row 10 has a latitude of 41.878 and longitude of -87.655. Therefore, when given the station coordinates, it cannot be ascertained which station the coordinates refer to. 
		- Result: the entries with null start station names/IDs and/or end start station names/IDs will be omitted.
