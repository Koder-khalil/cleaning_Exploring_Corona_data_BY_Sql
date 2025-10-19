-- real project corona data cleaning and Exploring by MySql

-- create database corona_db
create database if not exists  corona_db;
use corona_db;
-- import data from csv file by import table wizard
truncate corona_data;

-- load data to table from csv file
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/khalil/Downloads/corona_data.csv'
INTO TABLE corona_db.corona_data
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- show sum nulls vlue for columns

SELECT
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Proince,
    SUM(CASE WHEN 'Country/Region' IS NULL THEN 1 ELSE 0 END) AS 'Country/Region',
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS Latitude,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS Longitude,
    SUM(CASE WHEN 'Date' IS NULL THEN 1 ELSE 0 END) AS 'Date',
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS Confirmed,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS Deaths,
    SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS Recovered
FROM corona_db.corona_data;
-- Retrun Data Not Nulls 
-- check Total Rows
select count(*) from corona_db.corona_data;
-- return 36563 
-- check  count distinct data
select count(distinct(Province)) as count_province
from corona_data; 
-- 72 province 
-- Start date and end Date
-- change data type "Date' from text to Date
UPDATE corona_data
SET `Date` = STR_TO_DATE(`Date`, '%Y-%m-%d')
WHERE `Date` IS NOT NULL;

-- Change Data Type column Date from text to Date 
alter table corona_data
modify column `Date` Date;

select min(Date) as Start_date,max(Date) as end_date from corona_db.corona_data;
-- start Date 2020-01-22 to end date 2021-06-13
-- Number Of Months in dataset
select count(distinct(substr(`Date`,1,7))) as num_Months from corona_data;
-- return 18 Months Dataset
-- Find monthly Avrage confirmed Death Recovered
select distinct(substr(`Date`,1,7)) as Months, 
	round(avg(Confirmed),2) as Avg_omfired,
	round(avg(Deaths),2) as Avg_Deaths,
	round(avg(Recovered),2) as Avg_Recovered
from corona_data 
group by 1;
    
-- find minimum and Maximum Values per Months
select distinct(substr(`Date`,1,7)) as Months, 
	round(min(Confirmed),2) as min_Comfired,
    round(max(Confirmed),2) as Max_Comfired,
	round(min(Deaths),2) as min_Deaths,
    round(max(Deaths),2) as Max_Deaths,
	round(min(Recovered),2) as min_Recovered,
    round(max(Recovered),2) as Max_Recovered
from corona_data 
where Confirmed != 0 and Deaths != 0 and Recovered !=0
group by 1
order by 1 desc;  

--  Total Number Of Case Comfired , Deaths and Recovered each Month
select distinct(substr(`Date`,1,7)) as Months, 
	sum(Confirmed) as Sum_Comfired,
	sum(Deaths) as Sum_Deaths,
	Sum(Recovered) as Sum_Recovered
from corona_data 
group by 1;
    
-- find country highest number Comfirmed 
SELECT `Country/Region`, SUM(Confirmed) AS total_confirmed
FROM corona_data
GROUP BY `Country/Region`
ORDER BY total_confirmed DESC
LIMIT 1;
