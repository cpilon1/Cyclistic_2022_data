Cyclistic_2022_data
Cyclistic bikeshare data has been cleaned and aggregated using SQL and analysis visualized using Tableau. 

## Introduction
In the following case study, I will perform the real-world tasks of a junior data analyst for a fictitious bike-sharing company. To answer the business questions, I will follow the steps of the data analysis process: **Ask**, **Prepare**, **Process**, **Analyze**, **Share**, and **Act**.

### Background
Cyclistic is a bike-share company founded in 2016 in Chicago, Illinois. The company has more than 5,800 bicycles and 600 docking stations in the Chicago metropolitan area. Besides traditional bicycles and e-bikes, Cyclistic offers reclining bikes, hand tricycles and cargo bikes to make bike-sharing more inclusive to people with disabilities. The pricing plans offered are single-ride passes, full-day passes, and annual memberships.

## Ask
Cyclistic’s finance analysts have determined that annual memberships are more profitable than single-ride and day-passes. Cyclistic marketing director Lily Moreno believes converting casual riders into annual members is the best way to ensure the company’s growth. 

The goal of Moreno’s marketing team is to design strategies to convert casual users into annual members by determining 1) how casual users and annual members use Cyclistic bikes differently, 2) why casual riders would buy Cyclistic annual memberships, and 3) How Cyclistic can use digital media to influence casual riders to become members.

**Task:** Marketing Director Lily Moreno has assigned me the task of answering 1) How casual users and annual members use Cyclistic bikes differently. 

## Prepare

The data used is Cyclistic historical trip data for the year 2022. The files are publicly available from [Divvy](https://divvy-tripdata.s3.amazonaws.com/index.html) and made available by Motivate International Inc. ([view license](https://divvybikes.com/data-license-agreement).) Due to data-privacy regulations, riders’ personally identifiable information and payment information is not available.

The data files were uploaded to Google Cloud Services with public access prevention and Google-managed data encryption, and were also backed up to an external hard drive.

<img width="537" alt="Screenshot 2023-09-26 at 7 16 24 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/9e868573-883c-4cb3-b1dd-c40aae82cccd">

## Process
Due to the large amount of data, the [BigQuery SQL database platform](https://cloud.google.com/bigquery?utm_source=google&utm_medium=cpc&utm_campaign=na-none-all-en-dr-sitelink-all-all-trial-e-gcp-1605212&utm_content=text-ad-none-any-DEV_c-CRE_665665924750-ADGP_Hybrid+%7C+BKWS+-+MIX+%7C+Txt_BigQuery-KWID_43700077225652815-kwd-47616965283-userloc_9067609&utm_term=KW_bigquery-ST_bigquery-NET_g-&gclid=EAIaIQobChMIisiHto7JgQMVwfnICh2UmAfuEAAYASABEgJbSPD_BwE&gclsrc=aw.ds) was used to explore and clean the data. The following steps were taken to view, sort and filter the data.

### Explore the Data

The schema is shown in Figure 1 below.

Figure 1. Cyclistic metadata.
| Field Name | Type | Description |
|----------| ----------| ----------| 
| ride_id | string | Primary key; unique ID number for each bike trip |
| rideable_type | string | Bike type: electric_bike, classic_bike, or docked_bike |
| started_at | timestamp | date and time ride began |
| ended_at | timestamp | date and time ride ended |
| start_station_name | string | the name of the station where the trip began |
| start_station_id | string | unique ID number of the start station |
| end_station_name | string | the name of the station where the trip ended |
| end_station_id | string | unique ID number of the end station |
| start_lat | float | latitude of start location in decimal degrees |
| start_lng | float | longitude of start location in decimal degrees |
| end_lat | float | latitude of end location in decimal degrees |
| end_lng | float | longitude of end location in decimal degrees |
| member_casual | float | User type: member for subscribed user; casual for single-ride or 1-day pass |

To explore the data, the following steps were taken. 
1. Each file has uploaded to BigQuery successfully.
2. All tables were confirmed to have the same schema.
3. Null values exist in start_station_name, start_station_id, end_station_name, end_station_id, end_lat, and end_lng.
	- When a station name is null, the corresponding station ID is also null.
	- When the end_lat and end_lng values are null, the station name is not null. NOTE: Keep those rows.
	- Where the start_station_name/end_station_name is null, there are non-null start_lat, start_lng, end_lat and end_lng values. The close proximity of stations to one another makes it so that multiple stations have the same or similar coordinates when rounded to 4 decimal places. Therefore, when given the station coordinates, it is not certain which station the coordinates refer to.

4. There are trips less than 1 minute long and longer than 24 hours. NOTE: Omit these rows.
5. There are entries with docked bikes. NOTE: Omit these rows.
6. There are no spelling errors or extra spaces in rideable_type or member_type.
7. The string length for station names varies between 10-53 characters. Upon examining short and long string lengths, there were no string errors.

### Data Aggregation

- Tables 1-12 were aggregated using UNION ALL function.
- A table of station names and average latitude and longitude was created, called "station_coords1".

### Data Cleaning

The table used for analysis was created and filtered with the following information:
- exclude rideable_type = "docked_bike"
- calculate trip duration in minutes
- extract trip duration in month, day of week, time
- exclude NULL start_station_name and end_station_name
- exclude latitude and longitude values

### Data Validation

- The totals in tables 1-12 and the totals in aggregated table equal are equal.
- The amount of rows in cleaned data is equal to the aggregated data minus the removed data (docked bikes, null start or end station, trips <1 minute or > 24 hours).
- Prove that: R (removed data) + C (clean data) = D (original data)  
	Where $\Sigma$ R + $\Sigma$ C = $\Sigma$ Original Data  
  	R = $\Sigma$ entries removed due (bike only + station only + time only + bike & station + bike & time + station & time + bike & station & time)  
  	C = $\Sigma$ entries not removed
