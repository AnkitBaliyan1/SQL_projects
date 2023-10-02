**Problem Statement:**
An advertising agency is running a digital advertising campaign for a client. The campaign involves displaying ads on various online platforms. To evaluate the campaign's effectiveness and make data-driven decisions, the agency needs to analyze a dataset containing information about the campaign's performance, ad placements, and user interactions.

**Dataset Details:**

The dataset required for this project should include the following tables:

![database_schema](Schema_Model_view.jpeg)

1. **Campaign Data:**
   - `campaign_id` (unique identifier for each campaign)
   - `campaign_name` (name of the advertising campaign)
   - `start_date` (start date of the campaign)
   - `end_date` (end date of the campaign)
   - `budget` (total budget allocated for the campaign)

2. **Ad Placement Data:**
   - `ad_id` (unique identifier for each ad placement)
   - `campaign_id` (foreign key linking to the campaign it belongs to)
   - `platform` (the online platform where the ad was displayed, e.g., Facebook, Google Ads)
   - `placement_cost` (the cost incurred for placing the ad on the platform)

3. **User Interaction Data:**
   - `interaction_id` (unique identifier for each user interaction with an ad)
   - `ad_id` (foreign key linking to the ad placement)
   - `user_id` (unique identifier for each user)
   - `interaction_type` (e.g., click, view, conversion)
   - `interaction_date` (date and time when the interaction occurred)

**Questions to Answer using SQL:**

1. **Campaign Analysis:**
   - What is the total budget allocated for each campaign?
         
   **SQL Query:**
      
      ![budget_allocated](images/1.101_total_Budget_allocated.png) 
   
   **Output:**
      
      ![1.102_total_budget_allocated](images/1.102_total_budget_allocated.png)

   - How many campaigns are currently active? 1.201/2

   **SQL Query:**

      ![Active_campaigns](images/1.201_num_active_campaigns.png)

   **Output:**

      ![Active_campaigns_output](images/1.202_num_active_campaigns.png)


   - What is the average budget spent per active campaign? 1.301/2

   **SQL Query:**

      ![Budget Spent per active campaign](images/1.301_Avg_budget_per_active_campaign.png)

   **Output:**

      ![Budget Spent per active campaign](images/1.302_Avg_budget_per_active_campaign.png)
   
2. **Ad Placement Analysis:**
   - Which platform has the highest total placement cost?
   
   **SQL Query:**

      ![Highest_placement_cost](images/2.101_MaxPlaceCost_by_platform.png)

   **Output:**

      ![Highest_placement_cost_out](images/2.102_MaxPlaceCost_by_platform.png)

   - What is the average placement cost per platform?

   **SQL Query:**

      ![Avg_placement_cost_for_platform](images/2.201_Avg_placeCost_by_platform.png)

   **Output:**

      ![Avg_placement_cost_for_platform_out](images/2.202_Avg_placeCost_by_platform.png)

   - Which campaign has the highest total placement cost?

   **SQL Query:**

      ![highest_place_cost](images/2.301_MaxPlaceCost_by_campaign_name.png)

   **Output:**

      ![highest_place_cost_out](images/2.302_MaxPlaceCost_by_campaign_name.png)

3. **User Interaction Analysis:**
   - How many interactions (clicks) occurred for each ad placement? 3.101/2

   **SQL Query:**

      ![clicks_per_ad](images/3.101_interactions_per_ad_placement.png)

   **Output:**

      ![clicks_per_ad_out](images/3.102_interactions_per_ad_placement.png)

   - What is the average budget spend per click for each campaign? 3.201/2

   **SQL Query:**

      ![Avg_spend_per_click](images/3.201_spend_per_click.png)

   **Output:**

      ![Avg_spend_per_click_out](images/3.202_spend_per_click.png)


4. **Campaign Performance Analysis:**
   - What is the total spend for each campaign? 4.101/2

   **SQL Query:**

      ![Spend_for_each_campaign](images/4.101_spend_by_budget_for%20each_campiagn.png)

   **Output:**

      ![Spend_for_each_campaign_out](images/4.102_spend_by_budget_for%20each_campiagn.png)

   - How does the actual spend compare to the budget for each campaign? 4.201/1

   **SQL Query:**

      ![budget_vs_spend_by_campaign](images/4.201_spend_by_budget_for%20each_campiagn.png)

   **Output:**

      ![budget_vs_spend_by_campaign_out](images/4.202_spend_by_budget_for%20each_campiagn.png)


5. **Time-based Analysis:**
   - How do user interactions vary by day and time of day?  5.101/2

   **SQL Query:**

      ![interaction_over_month](images/5.101_monthly_unser_interaction_count.png)

   **Output:**

      ![interaction_over_month_out](images/5.102_monthly_unser_interaction_count.png)

   - How do user interactions vary by time of day? 5.201/2

   **SQL Query:**

      ![max_Interaction_within_day](images/5.201_highest_hits_in_day.png)

   **Output:**

   ![max_Interaction_within_day_out](images/5.202_highest_hits_in_day.png)

   - Is there a specific day of the week or time period that sees the highest user engagement? 5.301/2

   **SQL Query:**

      ![max_interaction_within_week](images/5.301_days_with_high_hits.png)

   **Output:**

      ![max_interaction_within_week_out](images/5.302_days_with_high_hits.png)

   
6. **Ad Engagement Analysis:**
   - What is the average number of interactions (clicks and views) per ad placement? 6.101/2

   **SQL Query:**



   **Output:**

      

   - Which ad placement had the highest total interactions? 6.201/2

   **SQL Query:**

      ![highest_interaction_by_ad](images/6.201_ad_with_max_hits.png)

   **Output:**

      ![highest_interaction_by_ad_out](images/6.202_ad_with_max_hits.png)


7. **Campaign Duration Analysis:**
   - How long did each campaign run in terms of days?

   **SQL Query:**

      ![campaign_duration](images/7.101_campaign_duration.png)

   **Output:**

      ![campaign_duration_out](/images/7.102_campaign_duration.png)

   - Analyse duration by interaction_type for each campaign.

   **SQL Query:**

      

   **Output:**

      


8. **Budget Allocation Analysis:**
   - How much of the budget is remaining for each active campaign?

   **SQL Query:**

      ![Remaining_budget](images/8.101_duration_by_interaction_type.png)

   **Output:**

      ![Remaining_budget_out](images/8.102_duration_by_interaction_type.png)


   

By answering these questions using SQL queries on the provided dataset, the advertising agency can gain valuable insights into the performance of the campaign, optimize budget allocation, and make data-driven decisions to improve ROI.


Creating a Business Intelligence (BI) dashboard with the dataset and SQL problems provided can offer valuable insights into your advertising campaign's performance. Here are some key performance indicators (KPIs) and charts you can create for your BI dashboard:

**Key Performance Indicators (KPIs):**

1. **Total Ad Campaigns:** Display the total number of ad campaigns currently in the dataset. This KPI gives an overview of the campaign volume.

2. **Total Ads Running:** Show the total number of ads currently active or running across all campaigns. This KPI provides insights into the scale of ad placements.

3. **User Interactions:** Present the total number of user interactions (clicks, views, and conversions) recorded across all campaigns. This KPI helps assess user engagement.

4. **Overall % of Budget Spent:** Calculate the percentage of the total budget spent compared to the allocated budget across all campaigns. This KPI offers insights into budget utilization.

5. **Average Campaign Duration:** Represent the average duration, in days, for all active advertising campaigns. It provides insights into the typical length of campaigns.


**Charts:**

1. **Time Series Chart for Total User Interactions:** Plot the total number of user interactions (clicks, views, and conversions) over time (e.g., daily, weekly, or monthly).

2. **Budget Allocation by Campaign Pie Chart:** Show a pie chart illustrating the allocation of the total budget across different campaigns.

3. **Placement Cost by Campaign Bar Chart:** Compare CTR for each campaign using a bar chart.

4. **Conversion Rate by campaign Bar Chart:** Compare the conversion rate for each campaign using bar chart.

5. **Interaction Type by Campaign Bar Chart:** Compare interaction type count for each campaign using a stacked bar chart.


These KPIs and charts will provide a comprehensive view of your advertising campaign's performance, helping you track progress, identify trends, and make data-driven decisions. I have choosen the most relavent ones based on my business problem statement.

