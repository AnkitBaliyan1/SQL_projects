

-- ALTER TABLE orderdetails drop column totalAmount;

# question starts from here














-- Find customers who have not made any purchases in the last 'n' months.



-- other queries

-- Customer Segmentation:




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

