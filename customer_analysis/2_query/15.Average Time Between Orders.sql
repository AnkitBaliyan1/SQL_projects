-- Average time between orders 
SELECT 
    customerNumber, 
    CAST(AVG(DATEDIFF(orderDate, prev_orderDate)) AS DECIMAL(10,2)) AS avg_time_between_orders
FROM (
    SELECT 
        customerNumber, 
        orderDate,
        LAG(orderDate) OVER (PARTITION BY customerNumber ORDER BY orderDate) AS prev_orderDate
    FROM orders
) t
GROUP BY customerNumber;