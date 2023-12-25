-- C. Monthly Trend for Orders

select * from pizza_sales;

select 
	monthname(order_date) as Month_name, 
    count(distinct order_id) as total_orders
from pizza_sales 
	group by Month_name
order by total_orders desc;