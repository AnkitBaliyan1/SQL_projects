-- Write a SQL query to find the average order amount for each customer.
SELECT 
	o.customerNumber, 
	CAST(AVG(totalAmount) AS DECIMAL(10,2)) AS avgOrderValuePerCustomer
FROM orderdetails od 
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY o.customerNumber;