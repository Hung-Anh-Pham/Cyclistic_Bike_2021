--Explore Merge table
SELECT
    COUNT(ride_id) num_ride,
    COUNT(Bike_type) numRow_BikeType,
    COUNT(Customer_type) numRow_CusType,
    COUNT(Start_date) numRow_StartDate,
    COUNT(End_date) numRow_EndDate,
    COUNT(station_name) numRow_station,
    COUNT(Latitude) numRow_latitude,
    COUNT(Longitude) numRow_long
FROM `my-case-study-2022.NewDivvy.Merge_Table`;
--Note: Only the station_name column has 4904254 row. That is the column has null values.

--Explore the Timestamp records
SELECT
    ride_id,
    Bike_type,
    Customer_type,
    TIMESTAMP_DIFF(End_date, Start_date, second) Ride_length
FROM `my-case-study-2022.NewDivvy.Merge_Table`
ORDER BY Ride_length;
--Notice: We have some negative number when substracting timestamp values

--Count how many records have errors in timestamp value.
SELECT 
    COUNTIF(TIMESTAMP_DIFF(End_date, Start_date, second)<0) Num_Errors_in_Time_Records
FROM `my-case-study-2022.NewDivvy.Merge_Table`;
--Eliminte the negative results to ensure data integrity

--Create a clean dataset
SELECT 
    EXTRACT(DATE from Start_date) Date,
    EXTRACT(TIME from TIMESTAMP_TRUNC(Start_date, HOUR)) Hour,
    ride_id,
    Bike_type,
    Customer_type,
    Station_name Station_name,
    Latitude,
    Longitude
FROM `my-case-study-2022.NewDivvy.Merge_Table`
WHERE TIMESTAMP_DIFF(End_date, Start_date, second) >= 0
ORDER BY Date, Hour;

--Create a Date table
SELECT DISTINCT 
    EXTRACT(DATE from Start_date) Calendar_date,
    EXTRACT(YEAR from Start_date) Calendar_year,
    EXTRACT(MONTH from Start_date) Calendar_month,
    EXTRACT(DAY from Start_date) Calendar_day,
    CASE
        WHEN EXTRACT(DAYOFWEEK from Start_date)=1 THEN 7
        WHEN EXTRACT(DAYOFWEEK from Start_date)=2 THEN 1
        WHEN EXTRACT(DAYOFWEEK from Start_date)=3 THEN 2
        WHEN EXTRACT(DAYOFWEEK from Start_date)=4 THEN 3
        WHEN EXTRACT(DAYOFWEEK from Start_date)=5 THEN 4
        WHEN EXTRACT(DAYOFWEEK from Start_date)=6 THEN 5
        ELSE 6
    END DayOfWeek,
    CASE
        WHEN EXTRACT(QUARTER from Start_date)=1 THEN "Quarter 1"
        WHEN EXTRACT(QUARTER from Start_date)=2 THEN "Quarter 2"
        WHEN EXTRACT(QUARTER from Start_date)=3 THEN "Quarter 3"
        ELSE "Quarter 4"
    END Quarter,
    CAST(EXTRACT(DATE from Start_date) AS STRING FORMAT 'MONTH') Month_name,
    CAST(EXTRACT(DATE from Start_date) AS STRING FORMAT 'DAY') Day_name
FROM `my-case-study-2022.NewDivvy.Merge_Table`
ORDER BY Calendar_date;

--Create a temperature table contain data from chicago
SELECT DISTINCT 
  date Temperature_date,
  ROUND(((AVG(temp)-32)/1.8),1) avg_Celsius,
FROM `bigquery-public-data.noaa_gsod.gsod2021`
WHERE wban = "94846" or wban="14819"
GROUP BY Temperature_date
ORDER BY Temperature_date;

--Summary the Clean table by Date
SELECT 
    Date,
    Hour,
    Customer_type,
    Bike_type,
    COUNT(ride_id) Total_rides
FROM `my-case-study-2022.NewDivvy.Clean_table`
GROUP BY Date, Hour, Customer_type, Bike_type
ORDER BY Date;

--Create the Geography summary table
SELECT  DISTINCT
    Station_name,
    AVG(Latitude) Latitude,
    AVG(Longitude) Longitude,
    COUNT(ride_id) Total_rides
FROM `my-case-study-2022.NewDivvy.Clean_table`
WHERE Station_name IS NOT NULL 
GROUP BY Station_name
ORDER BY Station_name;