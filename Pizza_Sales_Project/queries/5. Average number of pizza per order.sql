-- Average pizza per order

select * from pizza_sales;

select (sum(quantity) / count(distinct order_id)) as Avg_Pizza_per_Order from pizza_sales;