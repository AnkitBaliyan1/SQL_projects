-- 3. **User Interaction Analysis:**

-- How many interactions (clicks) occurred for each ad placement?
SELECT 
	ad_id, 
    count(*) as ClickCount
FROM 
	user_interaction_data
WHERE interaction_type = 'click'
GROUP BY ad_id;


-- What is the average budget spend per click for each campaign?
SELECT
    c.campaign_name,
    COUNT(u.interaction_id) AS click_count,
    CAST(Avg(a.placement_cost/u.interaction_id) AS DECIMAL(10,2)) AS spend_per_click
FROM campaign_data c
LEFT JOIN ad_placement_data a ON c.campaign_id = a.campaign_id
LEFT JOIN user_interaction_data u ON a.ad_id = u.ad_id AND u.interaction_type = 'click'
GROUP BY c.campaign_name;

select * from ad_placement_data;
