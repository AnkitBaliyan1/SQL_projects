-- Daily trend for total orders

select * from pizza_sales;

select 
	dayname(order_date) AS order_day , 
    count(distinct order_id) as total_orders 
from pizza_sales 
	group by 
    dayname(order_date) 
order by 
	total_orders desc;
