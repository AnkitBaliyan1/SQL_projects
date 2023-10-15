 -- query to get the list of employees in decending order as per their performance
  select 
	c.country,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    floor(sum(od.totalAmount)) as saleDone
 FROM customers c
 JOIN employees e on c.salesRepEmployeeNumber = e.employeeNumber
 JOIN orders o on c.customerNumber = o.customerNumber
 JOIN orderdetails od on o.orderNumber = od.orderNumber
 where salesRepEmployeeNumber is not null
 group by c.country,c.salesRepEmployeeNumber
 order by country desc , saleDone desc;