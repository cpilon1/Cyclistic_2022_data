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

Questions to consider during data analysis: 
- From which stations did annual members start and end their rides? From which stations did casual users start and end their rides?
- Which stations were the most popular for all riders?
- Which routes did annual members and casual users frequently use?
- What were the most popular time periods for riders (time of day, day of week, month of year)?
- How long were annual members trips compared to casual user trips?
- Which types of bicycles did annual members and casual users prefer?

## Prepare

The data used is Cyclistic historical trip data for the year 2022. The files are publicly available from [Divvy](https://divvy-tripdata.s3.amazonaws.com/index.html) and made available by Motivate International Inc. ([view license](https://divvybikes.com/data-license-agreement).) Due to data-privacy regulations, riders’ personally identifiable information and payment information is not available.

The data files were uploaded to Google Cloud Services with public access prevention and Google-managed data encryption, and were also backed up to an external hard drive.

<img width="537" alt="Screenshot 2023-09-26 at 7 16 24 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/9e868573-883c-4cb3-b1dd-c40aae82cccd">

## Process
Due to the large amount of data, the [BigQuery SQL database platform](https://cloud.google.com/bigquery?utm_source=google&utm_medium=cpc&utm_campaign=na-none-all-en-dr-sitelink-all-all-trial-e-gcp-1605212&utm_content=text-ad-none-any-DEV_c-CRE_665665924750-ADGP_Hybrid+%7C+BKWS+-+MIX+%7C+Txt_BigQuery-KWID_43700077225652815-kwd-47616965283-userloc_9067609&utm_term=KW_bigquery-ST_bigquery-NET_g-&gclid=EAIaIQobChMIisiHto7JgQMVwfnICh2UmAfuEAAYASABEgJbSPD_BwE&gclsrc=aw.ds) was used to explore and clean the data. The following steps were taken to view, sort and filter the data.

### Explore the Data  
[SQL query](https://github.com/cpilon1/Cyclistic_2022_data/blob/main/Data%20Exploration.sql)

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
[SQL query](https://github.com/cpilon1/Cyclistic_2022_data/blob/main/Data%20Aggregation.sql)

- Tables 1-12 were aggregated using UNION ALL function.
- A table of station names and average latitude and longitude was created, called "station_coords1".

### Data Cleaning  
[SQL query](https://github.com/cpilon1/Cyclistic_2022_data/blob/main/Data%20Cleaning.sql)

The table used for analysis was created and filtered with the following information:
- exclude rideable_type = "docked_bike"
- calculate trip duration in minutes
- extract trip duration in month, day of week, time
- exclude NULL start_station_name and end_station_name
- exclude latitude and longitude values

### Data Validation  
[SQL query](https://github.com/cpilon1/Cyclistic_2022_data/blob/main/Data%20Validation.sql)

- The totals in tables 1-12 and the totals in aggregated table equal are equal.
- The amount of rows in cleaned data is equal to the aggregated data minus the removed data (docked bikes, null start or end station, trips <1 minute or > 24 hours).
- Prove that: R (removed data) + C (clean data) = D (original data)  
	Where $\Sigma$ R + $\Sigma$ C = $\Sigma$ Original Data  
  	R = $\Sigma$ entries removed due (bike only + station only + time only + bike & station + bike & time + station & time + bike & station & time)  
  	C = $\Sigma$ entries not removed

## Analyze  
The biggest takeaways from data analysis were that use of Cyclistic bikes by casual users was distributed among fewer stations, during fewer months of the year, with longer ride durations and a preference for classic bikes. Annual members used a greater number of stations, had more users in the winter, and also preferred classic bikes. 
- The number of rides taken by annual members was 2561462 (62%), while the number of rides by casual members was 1557850 (38%).  
- Casual user rides were concentrated in the downtown area of Chicago on Ellis Avenue, State St, Morgan St and Calumet Ave. The annual members had more diversity in stations used, and included stations beyond downtown Chicago.  
- While summer months were the most popular times for Cyclistic riders, annual members were more likely to use the bikes during winter months.   Both causal users and annual members use bikes on weekdays and weekends, but the number of casual users using the bikes on the weekends was slightly higher than that of annual members.  
- Casual members on average used the bikes for longer periods of time than annual members 
- Both annual members and casual users preferred classic bikes. Among electric bike users, a greater proportion were casual users.

## Share

### Start Stations and End Stations  
The start and end stations used by annual members and casual users are compared in the charts below.  
**Recommendation:** Analyze why certain stations are popular with annual members, then aim marketing at casual users who use those stations. 

#### Start Stations   
[View Start Stations Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/StartStations?:language=en-US&:display_count=n&:origin=viz_share_link)   

<img width="800" alt="Screenshot 2023-09-30 at 5 00 44 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/41199b74-efee-4c01-b566-e808dd57d46d">


#### End Stations  
[View End Stations Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/EndStations?:language=en-US&:display_count=n&:origin=viz_share_link)  

<img width="800" alt="Screenshot 2023-10-03 at 5 47 09 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/dc59092f-4d7f-4701-9b3f-82f16d3660cc">


#### All Stations  
[View All Stations Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/Sheet7?:language=en-US&:display_count=n&:origin=viz_share_link)  

The number of annual member and casual user rides for the 20 most commonly-used stations are shown in the table below.  
- The table is ordered by the difference in rides between annual members and casual users. The stations used most by annual members but with few casual users are at the top of the table, while the stations used most by casual members with few annual members are at the bottom of the table.  
- The table includes the percent difference between annual members and casual users for each station (% Difference) and the total number of rides at each station for all users (% Total Rides).  

**Recommendation:** The stations at the top of the table (Kingsbury St & Kinzie St, Loomis St & Lexington St, Clinton St & Washington Blvd, etc.) can be analyzed further to see whether the casual users for these stations could become annual members.

<img width="800" alt="Screenshot 2023-10-03 at 5 52 55 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/500a9563-7093-4721-8f46-b27f38ef8921">

### Routes Taken  

[View Routes Taken Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/Routes?:language=en-US&:display_count=n&:origin=viz_share_link)

The routes used by annual members and casual users are compared below.  
**Recommendation:** Aim marketing at stations along Ellis Avenue, State St, Morgan St and Calumet Ave to convert casual users into annual members. 

<img width="800" alt="Screenshot 2023-09-30 at 5 02 17 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/733474cb-edcf-4e1c-9e25-296bf9bec2c5">
<br>

### Days of the Week  

[View Days of the Week Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/Days?:language=en-US&:display_count=n&:origin=viz_share_link)

Annual members use the bikes most on weekdays, while casual users use the bikes most on the weekends.  
**Recommendation:** Consider adopting a trial membership offer aimed at weekend users.

<img width="800" alt="Screenshot 2023-09-30 at 5 02 57 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/d868e3ac-7734-4aa5-a501-df1183baa64a">
<br>

### Months of the Year  

[View Months of the Year Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/Months?:language=en-US&:display_count=n&:origin=viz_share_link)

The months of May-October have the highest number of riders.  
**Recommendation:** Consider how to convince casual summer riders to become annual members.

<img width="800" alt="Screenshot 2023-09-30 at 5 03 55 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/5c6be4e7-db3b-4fb3-9d25-672cc246629c">
<br>

### Trip Duration  

[View Trip Duration Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/Duration?:language=en-US&:display_count=n&:origin=viz_share_link)

Casual users take longer rides than annual members, with a median ride time of 589 minutes (9 hours 49 minutes).  
**Recommendation:** Conduct further analysis to understand why casual users take longer rides.

<img width="800" alt="Screenshot 2023-09-30 at 5 11 38 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/5764f5ff-1c78-421b-a2ac-25d673730d72">

### Bike Types

[View Bike Types Visualization on Tableau](https://public.tableau.com/views/CPilon_Cyclistic_2022_Visualization/BikeTypes?:language=en-US&:display_count=n&:origin=viz_share_link)  

Annual members and casual users both use classic bikes the most. However, casual users use electric bikes 43% of the time, while annual members use them 34% of the time.  
**Recommendation:** Determine how to attract more casual users to become annual members through use of electric bikes.

<img width="600" alt="Screenshot 2023-10-03 at 6 06 26 PM" src="https://github.com/cpilon1/Cyclistic_2022_data/assets/144136275/faef4ee6-3c7e-4f0d-83a1-04f42e4248b6">

## Act    

The following recommendations are made to the Cyclistic marketing team:  
- Aim marketing strategies at casual users who use the stations and routes that are popular for annual members.
- Analyze weekdays and times of the year that are popular for annual members to use Cyclistic bikes and recruit casual users showing similar use patterns.
- Offer a deal for casual users to get a membership for electric bikes to convince casual users to become annual members.

Information that would be helpful in making further analyses:  
- Knowing the **distance traveled** during each ride would help in noticing trends in ride duration and location; 
- Associating each ride with a **customer ID** would allow us to see whether customers are making repeated trips, so that more direct marketing may be aimed at those users.

##### Project Reflection  
This was my first data analysis project. I had the opportunity to employ various data analysis tools and techniques, such as SQL, Tableau, and Google Sheets. Goals for the next project are to understand better how to use SQL sub-queries and how to use calculated fields in Tableau. - Crystal Pilon, October, 2023
