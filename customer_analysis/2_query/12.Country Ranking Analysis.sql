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