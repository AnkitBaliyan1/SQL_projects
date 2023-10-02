-- 8. **Budget Allocation Analysis:**
   -- How much of the budget is remaining for each active campaign?

select campaign_name, budget,
	CAST( sum(placement_cost) AS DECIMAL(10,2))as Ad_spent,
    CAST((budget - sum(placement_cost)) AS DECIMAL(10,2)) as Remaining_balance
FROM 
	campaign_data c
LEFT JOIN ad_placement_data a on a.campaign_id = c.campaign_id
where start_date <= CURRENT_DATE AND end_date >= CURRENT_DATE
GROUP BY campaign_name, budget;

   -- Is there a correlation between budget allocation and campaign performance?
   
select * from campaign_data;
select * from ad_placement_data;

SELECT
        c.campaign_id,
        c.campaign_name,
        c.budget AS campaign_budget,
        COUNT(u.interaction_id) AS total_user_interactions
    FROM campaign_data c
    LEFT JOIN ad_placement_data a ON c.campaign_id = a.campaign_id
    LEFT JOIN user_interaction_data u ON a.ad_id = u.ad_id
    GROUP BY c.campaign_id, c.campaign_name, campaign_budget;
    