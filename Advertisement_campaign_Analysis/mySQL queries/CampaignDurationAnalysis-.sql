-- 7. **Campaign Duration Analysis:**
   -- How long did each campaign run in terms of days?

SELECT 
	campaign_name, start_date, end_date, 
    DATEDIFF(end_date,start_date) as campaign_duration_days
FROM campaign_data;



   -- Did longer campaigns result in better performance?
SELECT 
	campaign_name,
    DATEDIFF(end_date,start_date) as campaign_duration_days,
    COUNT(u.interaction_type) as user_interaction,
    SUM(CASE WHEN u.interaction_type = 'click' THEN 1 ELSE 0 END) as totalClicks,
    SUM(CASE WHEN u.interaction_type = 'view' THEN 1 ELSE 0 END) as totalViers,
    SUM(CASE WHEN u.interaction_type = 'conversion' THEN 1 ELSE 0 END) as totalConversion
FROM 
	campaign_data c
LEFT JOIN ad_placement_data a on c.campaign_id = a.campaign_id
LEFT join user_interaction_data u on u.ad_id = a.ad_id
GROUP BY campaign_name, campaign_duration_days
ORDER BY campaign_duration_days desc;

