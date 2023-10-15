-- calculate the Customer Lifetime Value (CLV),
SELECT 
	o.customerNumber, 
	CAST(SUM(totalAmount) AS DECIMAL(10,2)) AS LifeTimeValue
FROM orderdetails od 
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY o.customerNumber
ORDER BY LifeTimeValue;