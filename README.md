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

The schema is shown in Figure 1 below. To explore the data, the following steps were taken. 

Figure 1. Cyclistic metadata.
  
<img width="399" alt="Screenshot 2023-09-26 at 6 58 03 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/1524a344-7385-4a4f-a771-68444061c32a">

1. Query each table to make sure it has **imported correctly** into BigQuery.
   - Result: All tables imported correctly.
2. Examine table schemas to ensure **uniformity across tables**.
   - Result: All tables have the same schema.
3. Check for **duplicate Ride IDs**.
	- Result: There were no duplicate Ride IDs.
4. Examine **nulls** in all fields.<br>
Figure 2. The number of null values found in each data set.<br>
<img width="663" alt="Screenshot 2023-09-26 at 7 46 53 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/87424b1c-e4a7-4a71-8174-58c9f55b8185"><br>
	- Result: There were nulls in start and end station names and IDs (Figure 1). When the station name was null, the station ID was also null.
		- Action: Determine possibility of using provided station coordinates to fill in the missing start and end station names.
			- Start by listing the latitude and longitude for each station name, rounded to .001. The station latitude and longitude vary by entry; for example, Aberdeen St & Monroe St has latitude values of 41.881 and 41.88 and longitude values of -87.656 and -87.655 in Rows 7 and 8, respectively (Figure 3). Furthermore, the close proximity of stations to one another makes it so that multiple stations have the same or similar coordinates; the nearby station Ada St & 113th St in row 10 has a latitude of 41.878 and longitude of -87.655. Therefore, when given the station coordinates, it cannot be ascertained which station the coordinates refer to.
	   		 - Result: the entries with null start station names/IDs and/or end start station names/IDs will be omitted.
       - Result: There were nulls in end station latitude and longitude (Figure 1).
       		- Action: The information for latitude and longitude can be added when the station name is known.



        Figure 3. Station name and corresponding latitude and longitude values.
        <img width="600" alt="Screenshot 2023-09-26 at 4 36 08 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/a3e51ac8-efd5-49df-9b77-695780dfe4a6">


6. Look for trips less than 1 minute or more than 24 hours.
	- Result: 121089 trips are less than 1 minute; 5360 are greater than/equal to 1 day. These trips will be omitted.
7. Check for bike type and user type errors and inconsistencies.
	- The string lengths for bike types and user type were consistent.
8. Check for station name errors and inconsistencies.
	- The string lengths for station names were consistent.
9. Check for entries where bike type is docked bike. The docked bikes are not in circulation and this data is to be omitted.
	- There were 177474 entries for docked bikes that will be omitted.



