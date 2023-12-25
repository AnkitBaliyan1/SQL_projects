-- E. % of Sales by Pizza Size

select * from pizza_sales;

select pizza_size,
	cast(sum(total_price) as decimal(10,2)) as Total_Revenue,
	cast(sum(total_price)*100 / (select sum(total_price) from pizza_sales) as decimal(5,2)) as PCT

from pizza_sales

group by pizza_size;