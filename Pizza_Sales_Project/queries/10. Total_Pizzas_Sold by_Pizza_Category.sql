-- F. Total Pizzas Sold by Pizza Category

select * from pizza_sales;

select 
	pizza_category,
	sum(quantity)
from pizza_sales
group by pizza_category;


-- pizza sold by category in particular month
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC