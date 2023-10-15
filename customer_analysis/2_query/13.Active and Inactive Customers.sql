-- 13. Active and Inactive Customers


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
		when month_diff < 6 then "Active" -- adjust this value
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



-- other methond using subqueries


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
