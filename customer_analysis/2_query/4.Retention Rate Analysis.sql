-- Write a SQL query to calculate the monthly customer retention rate, 
  -- considering customers who made purchases in two consecutive months.
WITH MonthlyUniqueCustomers AS (
    SELECT
        DATE_FORMAT(OrderDate, '%Y-%m') AS Month,
        COUNT(DISTINCT CustomerNumber) AS Unique_Customers
    FROM Orders
    GROUP BY DATE_FORMAT(OrderDate, '%Y-%m')
),
MonthlyRetention AS (
    SELECT
        DATE_FORMAT(a.OrderDate, '%Y-%m') AS From_Month,
        DATE_FORMAT(b.OrderDate, '%Y-%m') AS To_Month,
        COUNT(DISTINCT a.CustomerNumber) AS Retained_Customers
    FROM Orders a
    JOIN Orders b ON a.CustomerNumber = b.CustomerNumber
    WHERE TIMESTAMPDIFF(MONTH, a.OrderDate, b.OrderDate) = 1
    GROUP BY From_Month, To_Month
)
SELECT
    m.From_Month,
    m.To_Month,
    (CAST(m.Retained_Customers AS DECIMAL) / CAST(n.Unique_Customers AS DECIMAL)) * 100 AS Retention_Rate
FROM MonthlyRetention m
JOIN MonthlyUniqueCustomers n ON m.From_Month = n.Month
ORDER BY m.From_Month;