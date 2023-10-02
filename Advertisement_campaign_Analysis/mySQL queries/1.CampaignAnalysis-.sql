-- 1. **Campaign Analysis:**

-- What is the total budget allocated for each campaign?
SELECT 
	campaign_name AS CampaignName, 
    sum(budget) AS Budget
FROM campaign_data 
GROUP BY campaign_name;

-- How many campaigns are currently active?
SELECT COUNT(*) AS ActiveCampaigns
FROM campaign_data
WHERE start_date <= CURRENT_DATE
  AND end_date >= CURRENT_DATE;


-- What is the average budget spent per active campaign?
select 
	CAST(AVG(budget) AS DECIMAL(10,2)) AS Avg_Budget_Spent_Per_Active_Campaign
FROM campaign_data 
WHERE start_date <= CURRENT_DATE
  AND end_date >= CURRENT_DATE;
