-- 6. **Ad Engagement Analysis:**

-- What is the average number of interactions (clicks and views) per ad placement?
select * from user_interaction_data;

SELECT 
	ad_id, 
    CAST((count(interaction_type) / (select count(distinct ad_id) from user_interaction_data)) AS DECIMAL(10,2)) as Avg_Interaction_clicks_views 
FROM user_interaction_data 
WHERE interaction_type = 'click' or interaction_type = 'view'
GROUP BY ad_id
ORDER BY Avg_Interaction_clicks_views desc;




-- Which ad placement had the highest total interactions?

SELECT * FROM USER_INTERACTION_DATA;

SELECT ad_id, count(interaction_type) AS InteractionCount
FROM user_interaction_data
GROUP BY ad_id
ORDER BY InteractionCount DESC
LIMIT 1;