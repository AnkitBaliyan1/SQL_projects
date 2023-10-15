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
where lineRank=2;  -- change to get top N th country

-- Apparantely USA is top selling for all productline