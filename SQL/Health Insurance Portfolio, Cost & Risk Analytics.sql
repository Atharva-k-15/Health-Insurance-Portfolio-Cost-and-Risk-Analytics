create database Health_Insurance_Analytics;
show databases;
use Health_Insurance_Analytics;
show tables;

-- 1.How many unique customers are present?
select count(distinct person_id) as Unique_Customers from medical_insurance;

-- 2.Which columns contain missing or NULL values, and how many are missing in each?  
SET SESSION group_concat_max_len = 1000000;

SELECT GROUP_CONCAT(
    CONCAT(
        'SELECT ''', COLUMN_NAME, ''' AS column_name, ',
        'SUM(`', COLUMN_NAME, '` IS NULL) AS missing_values ',
        'FROM medical_insurance'
    )
    SEPARATOR ' UNION ALL '
)
INTO @sql
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'medical_insurance';

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3.Are there any duplicate customer IDs in the dataset?
select person_id, count(*) as Total_Numbers
from medical_insurance
group by person_id
having count(*) > 1;

-- 4.What are the minimum, maximum and average values of important numerical columns such as age, income, BMI and annual medical cost?
SELECT 'Age' AS Metric, MIN(age) AS `Minimum Value`, MAX(age) AS `Maximum Value`, ROUND(AVG(age),2) AS `Average Value`
FROM medical_insurance

UNION ALL

SELECT 'Income', MIN(income), MAX(income), ROUND(AVG(income),2)
FROM medical_insurance

UNION ALL

SELECT 'BMI', MIN(bmi), MAX(bmi), ROUND(AVG(bmi),2)
FROM medical_insurance

UNION ALL

SELECT 'Annual Medical Cost', MIN(annual_medical_cost), MAX(annual_medical_cost), ROUND(AVG(annual_medical_cost),2)
FROM medical_insurance;

-- 5.How many customers belong to each sex category?
select sex, count(*) as Total_Customers
from medical_insurance
group by sex;

-- 6.What is the distribution of customers across the five regions?
select region, count(*) as Total_Customers
from medical_insurance
group by region;

-- 7.How many customers belong to Urban, Suburban and Rural areas?
select urban_rural as Area, count(*) as Total_Customers
from medical_insurance
group by urban_rural;

-- 8.How are customers distributed across age groups?
SELECT
    CASE
        WHEN age < 18 THEN 'Below 18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Above 60'
    END AS age_group,
    COUNT(*) AS total_customers
FROM medical_insurance
GROUP BY age_group
ORDER BY MIN(age);

-- 9.How does the customer distribution vary across employment statuses?
select employment_status, count(*) as Total_Customers 
from medical_insurance
group by employment_status;

-- 10.What is the average income of customers across different education levels?
select education, sum(income) as Total_Income, count(*) as Total_Customers, avg(income) as Average_Income
from medical_insurance
group by education;

-- 11.Which insurance plans have the highest number of customers?
select plan_type, count(*) as Total_Customers
from medical_insurance
group by plan_type
order by Total_Customers desc;

-- 12.Compare customer distribution across combinations of region and insurance plan.
select region, plan_type, count(*) as Total_Customers
from medical_insurance
group by region, plan_type
order by region;

-- 13.What is the total and average annual medical cost across all customers?
select round(sum(annual_medical_cost),2) as Total_Medical_Cost, round(avg(annual_medical_cost),2) as Average_Medical_Cost
from medical_insurance;

-- 14.Which age groups have the highest average annual medical costs?
select case
		WHEN age < 18 THEN 'Below 18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Above 60'
	   end as age_group,
round(sum(annual_medical_cost),2) as Total_Medical_Cost,
count(*) as Total_Customers,
round(avg(annual_medical_cost),2) as Average_Medical_Cost
from medical_insurance
group by age_group
order by Average_Medical_Cost desc;

-- 15.How does total and average annual premium vary across different insurance plans?
select plan_type, round(sum(annual_premium),2) as Total_Annual_Premium, count(*) as Total_Customers,
round(avg(annual_premium),2) as Average_Annual_Premium
from medical_insurance
group by plan_type
order by Average_Annual_Premium;

-- 16.How do annual medical costs vary across different regions?
select region, round(sum(annual_medical_cost),2) as Total_Medical_Cost
from medical_insurance
group by region
order by Total_Medical_Cost desc;

-- 17.Which customer segments have the highest average medical expenditure?
select plan_type, region, round(AVG(annual_medical_cost),2) AS Average_Medical_Cost
FROM medical_insurance
GROUP BY plan_type, region
ORDER BY Average_Medical_Cost DESC;

-- 18.What is the difference between average annual medical cost and average annual premium for each insurance plan?
select plan_type, round(avg(annual_medical_cost),2) as Average_Medical_Cost, round(avg(annual_premium),2) as Average_Annual_Premium,
round(avg(annual_medical_cost) - avg(annual_premium),2) as Cost_Premium_Difference
from medical_insurance
group by plan_type;

-- 19.How do deductibles and copays vary across insurance plan types?
select plan_type, sum(deductible) as Deductibles_Sum, count(deductible) as Total_Deductibles, round(avg(deductible),2) as Average_Deductibles,
sum(copay) as Copays_Sum, count(copay) as Total_Copays, round(avg(copay),2) as Average_Copays
from medical_insurance
group by plan_type;

-- 20.Is there any relationship between customer income and annual medical expenditure?
SELECT CASE
        WHEN income < 25000 THEN 'Very Low Income'
        WHEN income <= 50000 THEN 'Low Income'
        WHEN income <= 100000 THEN 'Lower Middle Income'
        WHEN income <= 500000 THEN 'Upper Middle Income'
        ELSE 'High Income'
	   END as Income_Group,
count(*) as Total_Customers, round(sum(annual_medical_cost),2) as Total_Medical_Cost,
round(AVG(annual_medical_cost),2) as Average_Medical_Cost,
sum(income) as Total_Income, round(avg(income),2) as Average_Income
FROM medical_insurance
GROUP BY Income_Group
ORDER BY AVG(income);

-- 21.What is the total number of claims submitted across all customers?
select sum(claims_count) as Total_Claims from medical_insurance;

-- 22.What is the total amount of claims paid by the insurance portfolio?
select round(sum(total_claims_paid),2) as Total_Claim_Amount from medical_insurance;

-- 23.What is the average claim amount across all customers?
select round(avg(avg_claim_amount),2) as Average_Claim_Amount from medical_insurance;

-- 24.Which insurance plans have the highest total claims paid?
select plan_type, round(sum(total_claims_paid),2) as Total_Claims_Amount
from medical_insurance
group by plan_type
order by Total_Claims_Amount desc;

-- 25.Which regions have the highest average claim amount?
select region, round(sum(avg_claim_amount),2) as Total_Average_Claim_Amount
from medical_insurance
group by region
order by Average_Claim_Amount desc;

-- 26.Which customers have submitted the highest number of claims?
select person_id, claims_count as Claims_Count
from medical_insurance
order by Claims_Count desc;

-- 27.How does average claims activity vary between customers with different healthcare utilisation levels?
select case
		WHEN visits_last_year = 0 THEN 'No Visits'
        WHEN visits_last_year BETWEEN 1 AND 5 THEN 'Very Low Utilization'
        WHEN visits_last_year BETWEEN 6 AND 10 THEN 'Low Utilization'
        WHEN visits_last_year BETWEEN 11 AND 15 THEN 'Moderate Utilization'
        WHEN visits_last_year BETWEEN 16 AND 20 THEN 'High Utilization'
        ELSE 'Very High Utilization'
       end as Utilization_Level,
count(*) as Total_Customers,
sum(claims_count) as Total_Claims_Count,
round(avg(claims_count),2) as Average_Claims_per_Customer,
round(sum(total_claims_paid), 2) as Total_Claims_Paid,
round(avg(total_claims_paid), 2) as Average_Claim_Paid
from medical_insurance
group by Utilization_Level
order by min(visits_last_year);

-- 28.How many customers have each of the ten recorded chronic health conditions?
SELECT 'Hypertension' AS Health_Condition,
       SUM(hypertension) AS Total_Customers
FROM medical_insurance

UNION ALL

SELECT 'Diabetes', SUM(diabetes)
FROM medical_insurance

UNION ALL

SELECT 'Asthma', SUM(asthma)
FROM medical_insurance

UNION ALL

SELECT 'COPD', SUM(copd)
FROM medical_insurance

UNION ALL

SELECT 'Cardiovascular Disease', SUM(cardiovascular_disease)
FROM medical_insurance

UNION ALL

SELECT 'Cancer History', SUM(cancer_history)
FROM medical_insurance

UNION ALL

SELECT 'Kidney Disease', SUM(kidney_disease)
FROM medical_insurance

UNION ALL

SELECT 'Liver Disease', SUM(liver_disease)
FROM medical_insurance

UNION ALL

SELECT 'Arthritis', SUM(arthritis)
FROM medical_insurance

UNION ALL

SELECT 'Mental Health', SUM(mental_health)
FROM medical_insurance;

-- 29.Which chronic health conditions are most frequently recorded?
SELECT 'Hypertension' AS Health_Condition,
       SUM(hypertension) AS Total_Customers
FROM medical_insurance

UNION ALL

SELECT 'Diabetes', SUM(diabetes)
FROM medical_insurance

UNION ALL

SELECT 'Asthma', SUM(asthma)
FROM medical_insurance

UNION ALL

SELECT 'COPD', SUM(copd)
FROM medical_insurance

UNION ALL

SELECT 'Cardiovascular Disease', SUM(cardiovascular_disease)
FROM medical_insurance

UNION ALL

SELECT 'Cancer History', SUM(cancer_history)
FROM medical_insurance

UNION ALL

SELECT 'Kidney Disease', SUM(kidney_disease)
FROM medical_insurance

UNION ALL

SELECT 'Liver Disease', SUM(liver_disease)
FROM medical_insurance

UNION ALL

SELECT 'Arthritis', SUM(arthritis)
FROM medical_insurance

UNION ALL

SELECT 'Mental Health', SUM(mental_health)
FROM medical_insurance
order by Total_Customers desc;

-- 30.What is the average number of healthcare visits across different chronic-condition categories?
SELECT chronic_count, COUNT(*) AS Total_Customers, ROUND(AVG(visits_last_year), 2) AS Average_Healthcare_Visits
FROM medical_insurance
GROUP BY chronic_count
ORDER BY chronic_count;

-- 31.What is the average number of healthcare visits across every chronic health condition?
SELECT 'Hypertension' AS Health_Condition,
       ROUND(AVG(visits_last_year), 2) AS Average_Visits
FROM medical_insurance
WHERE hypertension = 1

UNION ALL

SELECT 'Diabetes', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE diabetes = 1

UNION ALL

SELECT 'Asthma', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE asthma = 1

UNION ALL

SELECT 'COPD', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE copd = 1

UNION ALL

SELECT 'Cardiovascular Disease', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE cardiovascular_disease = 1

UNION ALL

SELECT 'Cancer History', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE cancer_history = 1

UNION ALL

SELECT 'Kidney Disease', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE kidney_disease = 1

UNION ALL

SELECT 'Liver Disease', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE liver_disease = 1

UNION ALL

SELECT 'Arthritis', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE arthritis = 1

UNION ALL

SELECT 'Mental Health', ROUND(AVG(visits_last_year), 2)
FROM medical_insurance
WHERE mental_health = 1

ORDER BY Average_Visits DESC;

-- 32.How does average hospitalisation duration vary across customers with different numbers of chronic conditions?
select chronic_count, sum(days_hospitalized_last_3yrs) as Total_Hospitalization_Days, count(*) as Total_Customers,
avg(days_hospitalized_last_3yrs) as Average_Hospitalization_Days 
from medical_insurance
group by chronic_count
order by chronic_count;

-- 33.What is the average hospitalization duration across all the chronic health conditions?
SELECT 'Hypertension' AS Health_Condition,
       COUNT(*) AS Total_Customers,
       sum(days_hospitalized_last_3yrs) as Total_Hospitalization_Days,
       ROUND(AVG(days_hospitalized_last_3yrs), 3) AS Average_Hospitalization_Days
FROM medical_insurance
WHERE hypertension = 1

UNION ALL

SELECT 'Diabetes', COUNT(*),
	   sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE diabetes = 1

UNION ALL

SELECT 'Asthma', COUNT(*),
	   sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE asthma = 1

UNION ALL

SELECT 'COPD', COUNT(*),
       sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE copd = 1

UNION ALL

SELECT 'Cardiovascular Disease', COUNT(*),
	   sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE cardiovascular_disease = 1

UNION ALL

SELECT 'Cancer History', COUNT(*),
       sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE cancer_history = 1

UNION ALL

SELECT 'Kidney Disease', COUNT(*),
       sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE kidney_disease = 1

UNION ALL

SELECT 'Liver Disease', COUNT(*),
	   sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE liver_disease = 1

UNION ALL

SELECT 'Arthritis', COUNT(*),
       sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE arthritis = 1

UNION ALL

SELECT 'Mental Health', COUNT(*),
       sum(days_hospitalized_last_3yrs),
       ROUND(AVG(days_hospitalized_last_3yrs), 3)
FROM medical_insurance
WHERE mental_health = 1

ORDER BY Average_Hospitalization_Days DESC;

-- 34.How does medication count vary with the number of chronic conditions?
select chronic_count, count(*) as Total_Customers, sum(medication_count) as Total_Medication_Count,
round(avg(medication_count),2) as Average_Medication_Count
from medical_insurance
group by chronic_count
order by chronic_count;

-- 35.How does medication count vary with all the chronic health conditions?
SELECT
    'Hypertension' AS Health_Condition,
    COUNT(*) AS Total_Customers,
    SUM(medication_count) AS Total_Medication_Count,
    ROUND(AVG(medication_count), 2) AS Average_Medication_Count
FROM medical_insurance
WHERE hypertension = 1

UNION ALL

SELECT 'Diabetes', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE diabetes = 1

UNION ALL

SELECT 'Asthma', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE asthma = 1

UNION ALL

SELECT 'COPD', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE copd = 1

UNION ALL

SELECT 'Cardiovascular Disease', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE cardiovascular_disease = 1

UNION ALL

SELECT 'Cancer History', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE cancer_history = 1

UNION ALL

SELECT 'Kidney Disease', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE kidney_disease = 1

UNION ALL

SELECT 'Liver Disease', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE liver_disease = 1

UNION ALL

SELECT 'Arthritis', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE arthritis = 1

UNION ALL

SELECT 'Mental Health', COUNT(*), SUM(medication_count),
       ROUND(AVG(medication_count), 2)
FROM medical_insurance
WHERE mental_health = 1

ORDER BY Average_Medication_Count DESC;

-- 36.Which age groups have the highest average number of chronic conditions?
select * from medical_insurance;
select case
		WHEN age < 18 THEN 'Below 18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 45 THEN '31-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Above 60'
	   end as age_group,
count(*) as Total_Customers,
sum(chronic_count) as Total_Chronic_Count,
round(avg(chronic_count),2) as Average_Chronic_Count
from medical_insurance
group by age_group
order by Average_Chronic_Count desc;

-- 37.What is the average risk score across all customers?
select round(avg(risk_score),2) as Average_Risk_Score from medical_insurance;

-- 38.How many customers are classified as high-risk and non high-risk?
select case
		when is_high_risk = 0 then 'Non- High Risk'
        else 'High Risk'
	   end as Risk_Level,
count(*) as Total_Customers
from medical_insurance
group by Risk_Level
order by Risk_Level;

-- 39.What percentage of the customer portfolio is marked as high-risk?
SELECT COUNT(*) AS High_Risk_Customers, ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM medical_insurance),2) AS High_Risk_Percentage
FROM medical_insurance
WHERE is_high_risk = 1;

-- 40.How does the high-risk customer percentage vary across insurance plans?
SELECT plan_type, COUNT(*) AS Total_Customers,
SUM(CASE WHEN is_high_risk = 1 THEN 1 ELSE 0 END) AS High_Risk_Customers,
ROUND(100.0 * SUM(CASE WHEN is_high_risk = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS High_Risk_Percentage
FROM medical_insurance
GROUP BY plan_type
ORDER BY High_Risk_Percentage DESC;

-- 41.How does average risk score vary across different chronic-condition categories?
select chronic_count, count(*) as Total_Customers, round(sum(risk_score),2) as Total_Risk_Score,
round(avg(risk_score),2) as Average_Risk_Score
from medical_insurance
group by chronic_count
order by Average_Risk_Score desc;

-- 42.How do average annual medical costs differ between high-risk and non-high-risk customers?
select case
		when is_high_risk = 0 then 'Non- High Risk'
        else 'High Risk'
	   end as Risk_Level,
round(avg(annual_medical_cost),2) as Average_Annual_Cost
from medical_insurance
group by Risk_Level
order by Average_Annual_Cost desc;

-- 43.Rank insurance plans based on their average annual medical costs.
WITH Plan_Costs AS
(SELECT plan_type, AVG(annual_medical_cost) AS Average_Annual_Cost,
DENSE_RANK() OVER (ORDER BY AVG(annual_medical_cost) DESC) AS Ranking -- Can write this statement in directly below select part as well
FROM medical_insurance
GROUP BY plan_type)

SELECT plan_type, ROUND(Average_Annual_Cost, 2) AS Average_Annual_Cost, Ranking
FROM Plan_Costs
ORDER BY Ranking;

-- 44.Identify the top five customers with the highest total claims paid.
select person_id, total_claims_paid as Total_Claims_Paid
from medical_insurance
order by Total_Claims_Paid desc
limit 5;

-- 45.Compare each customer's annual medical cost with the average annual medical cost of their respective insurance plan.
SELECT person_id, plan_type, ROUND(annual_medical_cost, 2) AS Customer_Annual_Cost,
ROUND(AVG(annual_medical_cost) OVER(PARTITION BY plan_type),2) AS Plan_Average_Annual_Cost,
    CASE
	 WHEN annual_medical_cost > AVG(annual_medical_cost) OVER(PARTITION BY plan_type) THEN 'Above Plan Average'
     WHEN annual_medical_cost < AVG(annual_medical_cost) OVER(PARTITION BY plan_type) THEN 'Below Plan Average'
     ELSE 'Equal to Plan Average'
	END AS Cost_Comparison,
ROUND(annual_medical_cost - AVG(annual_medical_cost) OVER(PARTITION BY plan_type),2) AS Difference_From_Plan_Average
FROM medical_insurance
ORDER BY plan_type, person_id;

-- 46.Display insurance plans along with their cost comparisons (Calculated in Que 47th), total counts & value in the percentage.
with cte as
(SELECT person_id, plan_type, ROUND(annual_medical_cost, 2) AS Customer_Annual_Cost,
ROUND(AVG(annual_medical_cost) OVER (PARTITION BY plan_type), 2) AS Plan_Average_Annual_Cost,
ROUND(annual_medical_cost - AVG(annual_medical_cost) OVER (PARTITION BY plan_type), 2) AS Difference_From_Plan_Average,
CASE
    WHEN annual_medical_cost > AVG(annual_medical_cost) OVER (PARTITION BY plan_type)
    THEN 'Above Plan Average'
    WHEN annual_medical_cost < AVG(annual_medical_cost) OVER (PARTITION BY plan_type)
    THEN 'Below Plan Average'
    ELSE 'Equal to Plan Average'
END AS Cost_Comparison
FROM medical_insurance
ORDER BY plan_type, person_id)

-- 47.Identify the top 10% of customers with the highest total claims paid within each insurance plan.
-- Display their customer ID, insurance plan, total claims paid and ranking.
with cte as
(select plan_type, person_id, total_claims_paid as Total_Claims_Paid,
row_number() over(partition by plan_type order by total_claims_paid desc) as Ranking
from medical_insurance
order by plan_type),

ranked as
(select plan_type, person_id, Total_Claims_Paid, Ranking,
count(*) over(partition by plan_type) as Total_Customers
from cte)

select plan_type, person_id, Total_Claims_Paid, Ranking
from ranked
where Ranking <= ceil(Total_Customers * 0.1)
order by plan_type, Ranking;

-- 48.How do healthcare procedure patterns, average medical costs and claims expenditure vary across
-- different insurance plans and network tiers?
WITH Plan_Analysis AS
(SELECT plan_type, network_tier, COUNT(*) AS Total_Customers,
        SUM(proc_imaging_count) AS Total_Imaging,
        SUM(proc_surgery_count) AS Total_Surgeries,
        SUM(proc_physio_count) AS Total_Physio,
        SUM(proc_consult_count) AS Total_Consultations,
        SUM(proc_lab_count) AS Total_Lab_Procedures,
        ROUND(AVG(proc_imaging_count), 2) AS Avg_Imaging,
        ROUND(AVG(proc_surgery_count), 2) AS Avg_Surgeries,
        ROUND(AVG(proc_physio_count), 2) AS Avg_Physio,
        ROUND(AVG(proc_consult_count), 2) AS Avg_Consultations,
        ROUND(AVG(proc_lab_count), 2) AS Avg_Lab_Procedures,
        ROUND(100.0 * SUM(CASE WHEN had_major_procedure = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Major_Procedure_Percentage,
        ROUND(AVG(annual_medical_cost), 2) AS Average_Annual_Cost,
        ROUND(SUM(total_claims_paid), 2) AS Total_Claims_Expenditure,
        ROUND(AVG(provider_quality), 2) AS Average_Provider_Quality
FROM medical_insurance
GROUP BY plan_type, network_tier),

Ranked_Plans AS
(SELECT *, DENSE_RANK() OVER (ORDER BY Average_Annual_Cost DESC) AS Cost_Ranking
FROM Plan_Analysis
)
SELECT * FROM Ranked_Plans
ORDER BY Cost_Ranking, plan_type, network_tier;

-- 49.How does the proportion of high-risk customers vary across different regions, smoking categories and chronic-condition groups
-- and which customer segments have the highest average medical expenditure?
WITH Segment_Analysis AS
(SELECT region, smoker, chronic_count, COUNT(*) AS Total_Customers,
        SUM(CASE WHEN is_high_risk = 1 THEN 1 ELSE 0 END) AS High_Risk_Customers,
        ROUND(100.0 * SUM(CASE WHEN is_high_risk = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS High_Risk_Percentage,
        ROUND(AVG(risk_score), 2) AS Average_Risk_Score,
        ROUND(AVG(annual_medical_cost), 2) AS Average_Annual_Cost,
        ROUND(AVG(claims_count), 2) AS Average_Claims_Count,
        ROUND(AVG(visits_last_year), 2) AS Average_Healthcare_Visits
FROM medical_insurance
GROUP BY region, smoker, chronic_count
HAVING COUNT(*) >= 100),

Ranked_Segments AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY region ORDER BY High_Risk_Percentage DESC) AS Risk_Ranking
FROM Segment_Analysis)

SELECT * FROM Ranked_Segments
ORDER BY region, Risk_Ranking;

-- 50.Within each insurance plan, identify the top 10% of customers based on total claims paid and
-- compare their healthcare utilisation, procedure frequency and annual medical costs with the remaining customers.
WITH Ranked_Customers AS
(SELECT person_id, plan_type, total_claims_paid,
NTILE(10) OVER (PARTITION BY plan_type ORDER BY total_claims_paid DESC, person_id) AS Claims_Decile
FROM medical_insurance),

Customer_Segments AS
(SELECT m.*, r.Claims_Decile,
CASE WHEN r.Claims_Decile = 1 THEN 'Top 10%' ELSE 'Remaining 90%' END AS Customer_Group
FROM medical_insurance m
JOIN Ranked_Customers r
ON m.person_id = r.person_id),

Segment_Summary AS
(SELECT plan_type, Customer_Group, COUNT(*) AS Total_Customers,
        ROUND(AVG(total_claims_paid), 2) AS Avg_Total_Claims_Paid,
        ROUND(AVG(avg_claim_amount), 2) AS Avg_Claim_Amount,
        ROUND(AVG(annual_medical_cost), 2) AS Avg_Annual_Medical_Cost,
        ROUND(AVG(claims_count), 2) AS Avg_Claims_Count,
        ROUND(AVG(visits_last_year), 2) AS Avg_Healthcare_Visits,
        ROUND(AVG(hospitalizations_last_3yrs), 2) AS Avg_Hospitalizations,
        ROUND(AVG(days_hospitalized_last_3yrs), 2) AS Avg_Hospitalization_Days,
        ROUND(AVG(medication_count), 2) AS Avg_Medication_Count,
        ROUND(AVG(proc_imaging_count), 2) AS Avg_Imaging,
        ROUND(AVG(proc_surgery_count), 2) AS Avg_Surgeries,
        ROUND(AVG(proc_physio_count), 2) AS Avg_Physio,
        ROUND(AVG(proc_consult_count), 2) AS Avg_Consultations,
        ROUND(AVG(proc_lab_count), 2) AS Avg_Lab_Procedures,
        ROUND(AVG(proc_imaging_count + proc_surgery_count + proc_physio_count + proc_consult_count + proc_lab_count),2) AS Avg_Total_Procedures
FROM Customer_Segments
GROUP BY plan_type, Customer_Group),

Comparison AS
(SELECT *,
MAX(CASE WHEN Customer_Group = 'Top 10%' THEN Avg_Total_Claims_Paid END) OVER (PARTITION BY plan_type) AS Top10_Claims,
MAX(CASE WHEN Customer_Group = 'Remaining 90%' THEN Avg_Total_Claims_Paid END) OVER (PARTITION BY plan_type) AS Remaining_Claims,
MAX(CASE WHEN Customer_Group = 'Top 10%' THEN Avg_Annual_Medical_Cost END) OVER (PARTITION BY plan_type) AS Top10_Medical_Cost,
MAX(CASE WHEN Customer_Group = 'Remaining 90%' THEN Avg_Annual_Medical_Cost END) OVER (PARTITION BY plan_type) AS Remaining_Medical_Cost,
MAX(CASE WHEN Customer_Group = 'Top 10%' THEN Avg_Claims_Count END) OVER (PARTITION BY plan_type) AS Top10_Claims_Count,
MAX(CASE WHEN Customer_Group = 'Remaining 90%' THEN Avg_Claims_Count END) OVER (PARTITION BY plan_type) AS Remaining_Claims_Count,
MAX(CASE WHEN Customer_Group = 'Top 10%' THEN Avg_Total_Procedures END) OVER (PARTITION BY plan_type) AS Top10_Procedures,
MAX(CASE WHEN Customer_Group = 'Remaining 90%' THEN Avg_Total_Procedures END) OVER (PARTITION BY plan_type) AS Remaining_Procedures
FROM Segment_Summary)

SELECT plan_type, Customer_Group, Total_Customers,
Avg_Total_Claims_Paid, Avg_Claim_Amount, Avg_Annual_Medical_Cost, Avg_Claims_Count,
Avg_Healthcare_Visits, Avg_Hospitalizations, Avg_Hospitalization_Days, Avg_Medication_Count,
Avg_Imaging, Avg_Surgeries, Avg_Physio, Avg_Consultations, Avg_Lab_Procedures, Avg_Total_Procedures,
ROUND(100.0 * (Top10_Claims - Remaining_Claims) / NULLIF(Remaining_Claims, 0),2) AS Claims_Paid_Difference_Percentage,
ROUND(100.0 * (Top10_Medical_Cost - Remaining_Medical_Cost) / NULLIF(Remaining_Medical_Cost, 0),2) AS Medical_Cost_Difference_Percentage,
ROUND(100.0 * (Top10_Claims_Count - Remaining_Claims_Count) / NULLIF(Remaining_Claims_Count, 0),2) AS Claims_Count_Difference_Percentage,
ROUND(100.0 * (Top10_Procedures - Remaining_Procedures) / NULLIF(Remaining_Procedures, 0),2) AS Procedure_Difference_Percentage
FROM Comparison
ORDER BY plan_type, CASE WHEN Customer_Group = 'Top 10%' THEN 1 ELSE 2 END;