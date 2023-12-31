DROP TABLE IF EXISTS numbers_small;
CREATE TABLE numbers_small (number INT);
INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- Main-numbers table
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (number BIGINT);
INSERT INTO numbers
SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM numbers_small thousands, numbers_small hundreds, numbers_small tens, numbers_small ones
LIMIT 1000000;

-- Create Date Dimension table
DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date (
date_key          BIGINT PRIMARY KEY,
date             DATE NOT NULL,
year             INT,
month            CHAR(10),
month_of_year    CHAR(2),
day_of_month     INT,
day              CHAR(10),
day_of_week      INT,
weekend          CHAR(10) NOT NULL DEFAULT "Weekday",
day_of_year      INT,
week_of_year     CHAR(2),
quarter  INT,
UNIQUE KEY `date` (`date`));

-- First populate with ids and Date
-- Change year start and end to match your needs. The above sql creates records for year 2010.
INSERT INTO dim_date (date_key, date)
SELECT number, DATE_ADD( '2017-01-01', INTERVAL number DAY )
FROM numbers
WHERE DATE_ADD( '2017-01-01', INTERVAL number DAY ) BETWEEN '2017-01-01' AND '2022-11-01'
ORDER BY number;

-- Update other columns based on the date.
UPDATE dim_date SET
year            = DATE_FORMAT( date, "%Y" ),
month           = DATE_FORMAT( date, "%M"),
month_of_year   = DATE_FORMAT( date, "%m"),
day_of_month    = DATE_FORMAT( date, "%d" ),
day             = DATE_FORMAT( date, "%W" ),
day_of_week     = DAYOFWEEK(date),
weekend         = IF( DATE_FORMAT( date, "%W" ) IN ('Saturday','Sunday'), 'Weekend', 'Weekday'),
day_of_year     = DATE_FORMAT( date, "%j" ),
week_of_year    = DATE_FORMAT( date, "%V" ),
quarter         = QUARTER(date);