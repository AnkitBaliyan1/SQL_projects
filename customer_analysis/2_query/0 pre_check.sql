use Classicmodels;

SELECT * FROM employees;
SELECT * FROM offices;
SELECT * FROM customers;
SELECT * FROM payments;
SELECT * FROM orders;
SELECT * FROM orderdetails;
SELECT * FROM products;
SELECT * FROM productlines;


-- set safe update disable to update table.
SET SQL_SAFE_UPDATES = 0;
-- Add a new column to store the product of quantityOrdered and priceEach
ALTER TABLE orderdetails ADD COLUMN totalAmount DECIMAL(10, 2);
-- Update the totalAmount column with the product of quantityOrdered and priceEach
UPDATE orderdetails
SET totalAmount = quantityOrdered * priceEach;

SELECT * FROM orderdetails;