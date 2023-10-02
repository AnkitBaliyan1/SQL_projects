-- 3. **User Interaction Analysis:**

-- How many interactions (clicks) occurred for each ad placement?
SELECT 
	ad_id, 
    count(*) as ClickCount
FROM 
	user_interaction_data
WHERE interaction_type = 'click'
GROUP BY ad_id;


-- What is the click-through rate (CTR) for each campaign?
SELECT
    c.campaign_id,
    c.campaign_name,
    COUNT(u.interaction_id) AS click_count,
    CAST(COUNT(u.interaction_id)*100 / c.budget AS DECIMAL(10,2)) AS ctr
FROM campaign_data c
LEFT JOIN ad_placement_data a ON c.campaign_id = a.campaign_id
LEFT JOIN user_interaction_data u ON a.ad_id = u.ad_id AND u.interaction_type = 'click'
GROUP BY c.campaign_id, c.campaign_name, c.budget;
