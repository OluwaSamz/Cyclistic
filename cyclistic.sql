select top 5 ride_id, rideable_type, started_at, ended_at, member_casual, ride_length,
date_started, date_ended, time_started, time_ended, day_of_week, month_of_year
from PortfolioProject1..all_year


--create a table that combines all 12 months data
create table portfolioProject1..all_year (
ride_id nvarchar(255),
rideable_type nvarchar(255),
started_at datetime,
ended_at datetime,
start_station_name nvarchar(255),
start_station_id float,
end_station_name nvarchar(255),
end_station_id float,
start_lat float,
start_lng float,
end_lat float,
end_lng float,
member_casual nvarchar(255)
);

--add all 12 months data into the newly created table
insert into PortfolioProject1..all_year(
ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
)
(select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202106
UNION
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202107
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202108
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202109
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202110
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202111
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202112
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202201
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202202
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202203
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202204
union
select ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
from PortfolioProject1..trip_202205)


--------------------------------------------------------------DATA CLEANING and MANIPULATION-----------------------------------------------------------

--count all the rows of the new table
select count(*)
from PortfolioProject1..all_year

--split the date and time in the started_ at and ended_at column into seperate column
alter table PortfolioProject1..all_year
add date_started date

alter table PortfolioProject1..all_year
add date_ended date

alter table PortfolioProject1..all_year
add time_started time

alter table PortfolioProject1..all_year
add time_ended time

update PortfolioProject1..all_year
set date_started = convert(date,started_at)

update PortfolioProject1..all_year
set date_ended = convert(date,ended_at)

update PortfolioProject1..all_year
set time_started = convert(time,started_at)

update PortfolioProject1..all_year
set time_ended = convert(time,ended_at)


--create column for ride length and calculate
alter table PortfolioProject1..all_year
add ride_length

update PortfolioProject1..all_year
set ride_length = convert(time,(ended_at - started_at))


--add the day of week column
alter table PortfolioProject1..all_year
add day_of_week nvarchar(255)

update PortfolioProject1..all_year
set day_of_week = DATENAME(WEEKDAY,started_at)

--add month column
alter table PortfolioProject1..all_year
add month_of_year nvarchar(255)

update PortfolioProject1..all_year
set month_of_year = DATENAME(MONTH,started_at)


--identify duplicate rows
SELECT COUNT(ride_id) as ride_id_count
FROM PortfolioProject1..all_year
GROUP BY ride_id HAVING COUNT(ride_id) > 1;

--delete duplicate rows
DELETE FROM PortfolioProject1..all_year
WHERE ride_id IN (SELECT ride_id
FROM PortfolioProject1..all_year
GROUP BY ride_id HAVING COUNT(ride_id) > 1);

--checking where ended_at < started_at
select count(ride_length)
from PortfolioProject1..all_year
where ended_at < started_at

--delete where ended_at > started_at
delete
from PortfolioProject1..all_year
where ended_at < started_at


-----------------------------------------------------------ANALYSIS--------------------------------------------

--the columns i will be working with
select top 5 ride_id, rideable_type, started_at, ended_at, member_casual, ride_length, date_started, date_ended,
time_started, time_ended, day_of_week, month_of_year
from PortfolioProject1..all_year

--checking nulls in the important columns
SELECT * 
FROM PortfolioProject1..all_year
WHERE (ride_id is null or
		rideable_type is null or 
		started_at is null or	
		ended_at is null or 
		member_casual is null or 
		ride_length is null or	
		date_started is null or	
		date_ended is null or	
		time_started is null or	
		time_ended is null or 
		day_of_week is null or
		month_of_year is null)

select COUNT(distinct(ride_id))
from PortfolioProject1..all_year


--distinct members count
select member_casual, count(member_casual) as member_casual_count
from PortfolioProject1..all_year
group by member_casual

--identifying the various rideables used by the riders
select distinct(rideable_type)
from PortfolioProject1..all_year

--rideable preferred by riders
select member_casual, rideable_type, count(rideable_type) as rideable_count
from PortfolioProject1..all_year
group by member_casual, rideable_type


--average ride_length on each rideable per user
select member_casual, rideable_type,Cast(DateAdd(ms, AVG(CAST(DateDiff( ms, '00:00:00', cast(ride_length as time)) AS BIGINT)), '00:00:00' ) as Time ) 
as avg_ride_length
from PortfolioProject1..all_year
group by member_casual, rideable_type


-- average ride length per member type
SELECT member_casual, Cast(DateAdd(ms, AVG(CAST(DateDiff( ms, '00:00:00', cast(ride_length as time)) AS BIGINT)), '00:00:00' ) as Time ) 
as avg_ride_length
from PortfolioProject1..all_year
group by member_casual

--max ride length per member type
select member_casual, max(ride_length) as highest_ride_time
From PortfolioProject1..all_year
group by member_casual


--total ride on each day of the week per user type
select member_casual, day_of_week,count(day_of_week) as mode
From PortfolioProject1..all_year
group by member_casual, day_of_week
--order by mode desc


--avg_ride_length per day of the week
SELECT day_of_week, Cast(DateAdd(ms, AVG(CAST(DateDiff( ms, '00:00:00', cast(ride_length as time)) AS BIGINT)), '00:00:00' ) as Time ) 
as avg_ride_length
from PortfolioProject1..all_year
group by day_of_week
order by avg_ride_length desc


--average ride_length for users by day_of_week
SELECT member_casual, day_of_week, Cast(DateAdd(ms, AVG(CAST(DateDiff( ms, '00:00:00', cast(ride_length as time)) AS BIGINT)), '00:00:00' ) as Time ) 
as avg_ride_length
from PortfolioProject1..all_year
group by member_casual, day_of_week
order by avg_ride_length desc


-- Number of rides by day of the week per member type
SELECT member_casual, day_of_week, count(ride_id) as mode
from PortfolioProject1..all_year
group by member_casual, day_of_week
order by mode desc


