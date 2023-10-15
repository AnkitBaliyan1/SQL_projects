-- set safe update disable to update table.
SET SQL_SAFE_UPDATES = 0;
-- Add a new column to store the product of quantityOrdered and priceEach
ALTER TABLE orderdetails ADD COLUMN totalAmount DECIMAL(10, 2);
-- Update the totalAmount column with the product of quantityOrdered and priceEach
UPDATE orderdetails
SET totalAmount = quantityOrdered * priceEach;

-- ALTER TABLE orderdetails drop column totalAmount;

# question starts from here

-- Write a SQL query to find the average order amount for each customer.
SELECT 
	o.customerNumber, 
	CAST(AVG(totalAmount) AS DECIMAL(10,2)) AS avgOrderValuePerCustomer
FROM orderdetails od 
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY o.customerNumber;


-- calculate the Customer Lifetime Value (CLV),
SELECT 
	o.customerNumber, 
	CAST(SUM(totalAmount) AS DECIMAL(10,2)) AS LifeTimeValue
FROM orderdetails od 
JOIN orders o ON od.orderNumber = o.orderNumber
GROUP BY o.customerNumber
ORDER BY LifeTimeValue;


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


-- Write a SQL query to calculate the monthly customer retention rate, 
  -- considering customers who made purchases in two consecutive months.
WITH MonthlyUniqueCustomers AS (
    SELECT
        DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
        COUNT(DISTINCT CustomerNumber) AS Unique_Customers
    FROM Orders
    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
),
MonthlyRetention AS (
    SELECT
        DATE_FORMAT(a.OrderDate, '%Y-%m') AS From_Month,
        DATE_FORMAT(b.OrderDate, '%Y-%m') AS To_Month,
        COUNT(DISTINCT a.CustomerNumber) AS Retained_Customers
    FROM Orders a
    JOIN Orders b ON a.CustomerNumber = b.CustomerNumber
    WHERE TIMESTAMPDIFF(MONTH, a.OrderDate, b.OrderDate) = 1
    GROUP BY From_Month, To_Month
)
SELECT
    m.From_Month,
    m.To_Month,
    (CAST(m.Retained_Customers AS DECIMAL) / CAST(n.Unique_Customers AS DECIMAL)) * 100 AS Retention_Rate
FROM MonthlyRetention m
JOIN MonthlyUniqueCustomers n ON m.From_Month = n.Month
ORDER BY m.From_Month;



-- Find customers who have not made any purchases in the last 'n' months.



-- other queries

-- Customer Segmentation:
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
 
 -- query to get the list of employees in decending order as per their performance
  select 
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,
    c.country,
    floor(sum(od.totalAmount)) as saleDone
 FROM customers c
 JOIN employees e on c.salesRepEmployeeNumber = e.employeeNumber
 JOIN orders o on c.customerNumber = o.customerNumber
 JOIN orderdetails od on o.orderNumber = od.orderNumber
 where salesRepEmployeeNumber is not null
 group by c.salesRepEmployeeNumber,c.country
 order by country desc , saleDone desc;
 
 
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
 
 
-- employee with highest sales in each productline
with employeeSalesProductline as (
	select 
    p.productLine,
    CONCAT(e.firstName, ' ', e.lastName) AS employeeName,    
    sum(od.totalAmount) as sales,
    row_number() over (partition by p.productline order by sum(od.totalAmount) desc) as lineRank
    from employees e
    join customers c on c.salesRepEmployeeNumber = e.employeeNumber
    join orders o on o.customerNumber = c.customerNumber
    join orderdetails od on od.orderNumber = o.orderNumber
    join products p on p.productCode = od.productCode
    group by p.productLine, employeeName
)
select productLine, employeeName, sales from employeeSalesProductline
where lineRank=1
order by sales desc;


-- country wise product sold
with employeeSalesProductline as (
	select 
    p.productLine,
    c.country,
    sum(od.totalAmount) as sales,
    row_number() over (partition by p.productline order by sum(od.totalAmount) desc) as lineRank -- window function
from employees e
    join customers c on c.salesRepEmployeeNumber = e.employeeNumber
    join orders o on o.customerNumber = c.customerNumber
    join orderdetails od on od.orderNumber = o.orderNumber
    join products p on p.productCode = od.productCode
    group by p.productLine, c.country
)
select productLine, country, sales from employeeSalesProductline
where lineRank=1;



-- all the product line has highest sales in USA and 
 -- Spain is second highest sales market for most of other.


-- using window function to get top successfull and worst product in each country
with combineTable as (
	select 
	c.country, 
    first_value (p.productLine) over w as top_selling,
    nth_value (p.productLine,2) over w as second_top_selling,
    last_value (p.productLine) over w as least_selling
    from customers c 
    join orders o on c.customerNumber = o.customerNumber
    join orderdetails od on od.orderNumber = o.orderNumber
    join products p on p.productCode = od.productCode
    group by c.country, p.productline
    window w as (partition by c.country order by sum(totalAmount) desc
				range between unbounded preceding and unbounded following)
),
country_group as (
select * from combineTable
group by country, top_selling, second_top_selling, least_selling
),
top_selling_country_count as (
select least_selling as product,
	count(country) as worst_in_countries
    from country_group 
    group by least_selling)
select * from country_group; -- Main Query





-- find number of offices in a country, number of orders, and salesAmount 
select 
    c.country,
	count(distinct o.officeCode) as officeCNT,
    count(distinct od.orderNumber) as orderCNT,
    cast((sum(totalAmount)/100000) as decimal(10,2)) as "sales (*100,000)",
    row_number() over (order by count(distinct o.officeCode) desc) as officeRank,
    row_number() over (order by count(distinct od.orderNumber) desc) as orderRank,
    row_number() over (order by sum(totalAmount) desc) as salesRank
from offices o 
join employees e on e.officeCode = o.officeCode
join customers c on c.salesRepEmployeeNumber = e.employeeNumber
join orders ord on ord.customerNumber = c.customerNumber
join orderdetails od on ord.orderNumber = od.orderNumber
group by c.country
order by salesRank;


-- using CTE
with rankCountries as (
select 
    c.country as country,
	count(distinct o.officeCode) as officeCNT,
    count(distinct od.orderNumber) as orderCNT,
    sum(totalAmount) as sales
from offices o 
join employees e on e.officeCode = o.officeCode
join customers c on c.salesRepEmployeeNumber = e.employeeNumber
join orders ord on ord.customerNumber = c.customerNumber
join orderdetails od on ord.orderNumber = od.orderNumber
group by c.country
)
select country, officeCNT, orderCNT, sales,
	row_number() over (order by officeCNT desc) as officeRank,
    row_number() over (order by orderCNT desc) as orderRank,
    row_number() over (order by sales desc) as salesRank
from rankCountries;


# file output done till here 

-- from here it is a new file output

# -- inactive customers 


with orderRecord as (
SELECT 
	c.customerNumber, 
    o.min_orderDate as first_orderDate,
    o.max_orderDate as last_orderDate,
    total_orders
FROM customers c
	JOIN (
		SELECT customerNumber, 
		date_Format (max(orderDate),'%Y-%m') as max_orderDate,
		date_format(min(orderdate),'%Y-%m') as min_orderDate,
		count(distinct orderNumber) as total_orders
		FROM orders
		GROUP BY customerNumber
	) o
	ON c.customerNumber = o.customerNumber
	order by total_orders desc
),
-- to add cutoff date in each column
recordtable as (
select customerNumber,
	first_orderDate, 
    last_orderDate,
    total_orders,
    (select date_format(orderDate,'%Y-%m') as cutoffDate 
	from orders 
	where orderDate = (select max(orderDate) from orders)
	group by orderDate) as cutoffDate
from orderRecord),

finalTable as (
select customerNumber,
	first_orderDate, 
    last_orderDate,
    total_orders,
    cutoffDate,
	TIMESTAMPDIFF(MONTH, STR_TO_DATE(CONCAT(last_orderDate, '-01'), '%Y-%m-%d'), STR_TO_DATE(CONCAT(cutoffDate, '-01'), '%Y-%m-%d')) AS month_diff
from recordTable)
,
output_1 as (
select 
	customerNumber, 
	last_orderDate,
    month_diff as months_since_last_order,
    case 
		when month_diff < 5 then "Active" -- adjust this value
        else "Inactive"
        end as Status
from finalTable)

select 
	months_since_last_order as months, 
	count(status) as ActiveCustomers 
from output_1 
where status='active'
group by months_since_last_order
order by months_since_last_order;




select * ,
	case 
		when month_diff < 2 then "Active" else "Inactive" end as Status-- adjust this value 
from (
		SELECT 
			c.customerNumber, 
			o.min_orderDate as first_orderDate, o.max_orderDate as last_orderDate,
			total_orders, cutoffDate,
			TIMESTAMPDIFF(MONTH, 
				STR_TO_DATE(CONCAT(o.max_orderDate, '-01'), '%Y-%m-%d'), 
				STR_TO_DATE(CONCAT(cutoffDate, '-01'), '%Y-%m-%d')) 
			AS month_diff
		FROM customers c
JOIN (
		SELECT customerNumber, 
		date_Format (max(orderDate),'%Y-%m') as max_orderDate,
		date_format(min(orderdate),'%Y-%m') as min_orderDate,
		count(distinct orderNumber) as total_orders
		FROM orders
		GROUP BY customerNumber
	) o
		ON c.customerNumber = o.customerNumber
JOIN (
		select 
			customerNumber,
			(select date_format(orderDate,'%Y-%m') as cutoffDate 
			from orders 
			where orderDate = (select max(orderDate) from orders)
			group by orderDate) as cutoffDate
		from orders
    ) cut 
		ON c.customerNumber = cut.customerNumber
group by customerNumber
order by total_orders desc) a;




-- most popular product for each region 
with cte as (
select *, 
row_number() over(partition by country order by unitSold desc) as productRank
from 
	(select 
		c.country, productName, count(productName) as unitSold
	from 
		Customers c 
		join (select customerNumber, orderNumber from orders) o on o.customerNumber = c.customerNumber
		join (select orderNumber, productCode from orderDetails) od on od.orderNumber = o.orderNumber
		join (select productCode, productName from products) p on p.productCode = od.productCode
	group by c.country, productName) subQuery
    )
    select country, productName as topSelligProduct, unitSold from cte
    where productRank=1
    order by unitSold desc;
    
    

-- Average time between orders 
SELECT 
    customerNumber, 
    CAST(AVG(DATEDIFF(orderDate, prev_orderDate)) AS DECIMAL(10,2)) AS avg_time_between_orders
FROM (
    SELECT 
        customerNumber, 
        orderDate,
        LAG(orderDate) OVER (PARTITION BY customerNumber ORDER BY orderDate) AS prev_orderDate
    FROM orders
) t
GROUP BY customerNumber;


CREATE INDEX idx_customer_name ON customers (customerName);
SHOW INDEX FROM customers;


DROP INDEX idx_customer_name ON customers;
