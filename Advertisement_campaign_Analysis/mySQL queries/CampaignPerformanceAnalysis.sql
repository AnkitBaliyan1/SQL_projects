-- 4. **Campaign Performance Analysis:**


-- What is the total spend for each campaign?
SELECT 
	campaign_name, 
    CAST(a.placement_cost AS DECIMAL(10,2)) as TotalSpend
FROM campaign_data c 
JOIN (select campaign_id, placement_cost from ad_placement_data) a
on a.campaign_id = c.campaign_id;

-- How does the actual spend compare to the budget for each campaign?
SELECT 
	campaign_name, budget AS CampaignBudget,
    CAST(SUM(a.placement_cost) AS DECIMAL(10,2)) as TotalActualSpend,
    CAST(c.budget - SUM(a.placement_cost) AS DECIMAL(10,2)) as RemainingBudget
FROM campaign_data c 
LEFT JOIN  ad_placement_data a
on a.campaign_id = c.campaign_id
GROUP BY c.campaign_id, c.campaign_name, c.budget;

