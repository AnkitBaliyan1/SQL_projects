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
				range between unbounded preceding and unbounded following)   -- using window function
),
country_group as (
select * from combineTable
group by country, top_selling, second_top_selling, least_selling
),
top_selling_country_count as (
select top_selling as product,
	count(country) as top_in_countries
    from country_group 
    group by top_selling
),
worst_selling_country_count as (
select least_selling as product,
	count(country) as worst_in_countries
    from country_group 
    group by least_selling)
    
select * from top_selling_country_count; -- Main Query / change to worst_selling_country_count to get num of coutnries product is top selling and worst selling