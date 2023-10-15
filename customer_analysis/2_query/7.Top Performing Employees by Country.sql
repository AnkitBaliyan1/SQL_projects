 -- write query to find rank employe for each country as per sales 
  select 
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    c.country,
    floor(sum(od.totalAmount)) as saleDone,
    ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY SUM(od.totalAmount) DESC) AS countryRank
 FROM customers c
 JOIN employees e on c.salesRepEmployeeNumber = e.employeeNumber
 JOIN orders o on c.customerNumber = o.customerNumber
 JOIN orderdetails od on o.orderNumber = od.orderNumber
 where salesRepEmployeeNumber is not null
 group by c.salesRepEmployeeNumber,c.country
 order by country desc ;


-- write query to find best employe for each country
  select 
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    c.country,
    floor(sum(od.totalAmount)) as saleDone,
    ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY SUM(od.totalAmount) DESC) AS countryRank
 FROM customers c
 JOIN employees e on c.salesRepEmployeeNumber = e.employeeNumber
 JOIN orders o on c.customerNumber = o.customerNumber
 JOIN orderdetails od on o.orderNumber = od.orderNumber
 where salesRepEmployeeNumber is not null
 group by c.salesRepEmployeeNumber,c.country
 order by country desc , saleDone desc;
 
 -- using cte : common table expression
 with rankedEmployee as (
 select 
    c.country,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    floor(sum(od.totalAmount)) as saleDone,
    ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY SUM(od.totalAmount) DESC) AS countryRank
 FROM customers c
 JOIN employees e on c.salesRepEmployeeNumber = e.employeeNumber
 JOIN orders o on c.customerNumber = o.customerNumber
 JOIN orderdetails od on o.orderNumber = od.orderNumber
 where salesRepEmployeeNumber is not null
 group by c.salesRepEmployeeNumber,c.country
 )
 
select country, employeeName, SaleDone from rankedEmployee
 where countryRank=1
 order by saleDone desc;