-- most popular product for each country 
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