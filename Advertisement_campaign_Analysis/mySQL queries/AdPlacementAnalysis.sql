-- 2. **Ad Placement Analysis:**

-- Which platform has the highest total placement cost?
SELECT 
	platform, 
    CAST(MAX(placement_cost) AS DECIMAL(10,2)) AS MaxPlaceCost
FROM ad_placement_data
GROUP BY platform;


-- What is the average placement cost per platform?
SELECT 
	platform, 
    CAST(AVG(placement_cost) AS DECIMAL(10,2)) AS AvgPlaceCost
FROM ad_placement_data
GROUP BY platform;


-- Which campaign has the highest total placement cost?
select campaign_name,
	CAST(MAX(a.placement_cost) AS DECIMAL(10,2)) AS MaxPlaceCost
FROM campaign_data c 
LEFT JOIN ad_placement_data a ON c.campaign_id = a.campaign_id
GROUP BY campaign_name;