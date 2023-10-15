-- number of orders from a country in a month 
 SELECT c.country, 
    COUNT(DISTINCT orderNumber) as orderCount
    from orders o
JOIN customers c ON c.customerNumber = o.customerNumber
GROUP BY c.country
order by orderCount desc;

 -- find which employee driving more order count and order by values
 select 
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
	count(distinct customerNumber) as customerServed
 FROM customers c
 JOIN employees e on c.salesRepEmployeeNumber = e.employeeNumber
 where salesRepEmployeeNumber is not null
 group by salesRepEmployeeNumber;