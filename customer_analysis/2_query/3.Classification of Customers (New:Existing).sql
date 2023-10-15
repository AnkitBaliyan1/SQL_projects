-- Write a query to classify customer by Status (New and Existing) by Month.
SELECT o.customerNumber, c.customerName as custName,
	o.orderDate AS orderDate,
    fd.firstPurchaseMonth AS firstPurchaseDate,
	if(month(o.orderDate) = month(fd.firstPurchaseMonth), 'New','Existing') AS Status
FROM orders o
JOIN (
    SELECT customerNumber, MIN(orderDate) as firstPurchaseMonth
    FROM orders
    GROUP BY customerNumber
) fd ON fd.customerNumber = o.customerNumber
JOIN customers c ON c.customerNumber = o.customerNumber;