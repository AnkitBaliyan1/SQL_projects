-- 5. **Time-based Analysis:**

   -- How do user interactions vary by day and time of day?
SELECT
    DATE(interaction_date) AS InteractionDay,
    COUNT(*) AS InteractionCount
FROM user_interaction_data
GROUP BY interactionDay
ORDER BY interactionDay;


   -- Is there a specific day of the week or time period that sees the highest user engagement?

SELECT
    DAYNAME(interaction_date) AS DayOfWeek,
    COUNT(*) AS InteractionCount
FROM user_interaction_data
GROUP BY DayOfWeek
ORDER BY InteractionCount DESC
LIMIT 1;


SELECT
    EXTRACT(HOUR FROM interaction_date) AS Hour_of_Day,
    COUNT(*) AS InteractionCount
FROM user_interaction_data
GROUP BY Hour_of_Day
ORDER BY InteractionCount DESC
LIMIT 1;

