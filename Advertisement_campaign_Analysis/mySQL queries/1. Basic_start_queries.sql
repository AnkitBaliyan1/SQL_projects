show databases;

use advertisement_database;

show tables;

select * from campaign_data;
desc campaign_data;

select * from ad_placement_data;
desc ad_placement_data;

select * from user_interaction_data;
desc user_interaction_data;


-- Handling start date column to be read as datetime
ALTER TABLE campaign_data
ADD start_date_column DATE;  -- add extra date column

SET SQL_SAFE_UPDATES = 0;  -- in order to update and change datatype, changing mySQL settings

UPDATE campaign_data
SET start_date_column = STR_TO_DATE(start_date, '%Y-%m-%d');  -- Update the new date column with the converted values

ALTER TABLE campaign_data
DROP COLUMN start_date;   -- deleting order_date column which is text type

ALTER TABLE campaign_data
CHANGE COLUMN start_date_column start_date datetime;   -- renaming new column 


-- Handling end date column to be read as datetime
ALTER TABLE campaign_data
ADD end_date_column DATE;  -- add extra date column

UPDATE campaign_data
SET end_date_column = STR_TO_DATE(end_date, '%Y-%m-%d');  -- Update the new date column with the converted values

ALTER TABLE campaign_data
DROP COLUMN end_date;   -- deleting order_date column which is text type

ALTER TABLE campaign_data
CHANGE COLUMN end_date_column end_date datetime;   -- renaming new column 

describe campaign_data;   -- recheck datatype 