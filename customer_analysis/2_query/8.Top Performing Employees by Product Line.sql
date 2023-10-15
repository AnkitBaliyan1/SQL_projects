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