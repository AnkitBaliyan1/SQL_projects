-- Average Order Value

select (sum(total_price) / count(distinct order_id)) as Average_Order_Value from pizza_sales;