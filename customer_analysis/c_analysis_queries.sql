
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
select * from top_selling_country_count; -- Main Query








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
