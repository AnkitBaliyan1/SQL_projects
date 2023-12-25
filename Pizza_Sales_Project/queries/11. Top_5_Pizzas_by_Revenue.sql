-- G. Top 5 Pizzas by Revenue

select * from pizza_sales;

select pizza_name, cast(sum(total_price) as decimal(10,2)) as Revenue
from pizza_sales
group by pizza_name
order by Revenue desc
limit 5;


-- Bottom 5 Pizzas by Revenue

select pizza_name, cast(sum(total_price) as decimal(10,2)) as Revenue
from pizza_sales
group by pizza_name
order by Revenue asc
limit 5;


-- Top 5 Pizzas by Quantity
select pizza_name, cast(sum(quantity) as decimal(10,1)) as Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold desc
limit 5;

-- Bottom 5 Pizzas by Quantity
select pizza_name, cast(sum(quantity) as decimal(10,1)) as Total_pizza_sold
from pizza_sales
group by pizza_name
order by Total_pizza_sold asc
limit 5;


-- Top 5 Pizzas by Total Orders
select pizza_name, cast(count(distinct order_id) as decimal(10,0)) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders desc
limit 5;


-- Bottom 5 Pizzas by Total Orders
select pizza_name, cast(count(distinct order_id) as decimal(10,0)) as Total_orders
from pizza_sales
group by pizza_name
order by Total_orders asc
limit 5;
