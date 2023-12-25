-- To begin with queries,

show databases;

-- select database to work with
use pizza;

-- show all tables in the current database
show tables;

desc pizza_sales;


-- In order to read correct datatype for date column, we run following queries


ALTER TABLE pizza_sales
ADD date_column DATE;  -- add extra date column

SET SQL_SAFE_UPDATES = 0;  -- in order to update and change datatype, changing mySQL settings

UPDATE pizza_sales
SET date_column = STR_TO_DATE(order_date, '%d-%m-%Y');  -- Update the new date column with the converted values

ALTER TABLE pizza_sales
DROP COLUMN order_date;   -- deleting order_date column which is text type

ALTER TABLE pizza_sales
CHANGE COLUMN date_column order_date datetime;   -- renaming new column 

describe pizza_sales;   -- recheck datatype 
