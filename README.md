# Health Insurance Portfolio, Cost & Risk Analytics

## 1. Project Overview

This project focuses on analysing a customer-level health insurance dataset to understand insurance portfolio composition, healthcare expenditure, claims patterns, recorded health-risk indicators and healthcare utilisation.

The objective is to explore customer demographics, compare insurance plans, examine medical costs and claims, and identify patterns across chronic conditions and recorded risk categories.

The project follows an end-to-end data analytics workflow using Python, MySQL, Microsoft Excel and Power BI, transforming raw customer-level data into meaningful analytical insights.

## 2. Business Problem Statement

Health insurance organisations work with customer, policy, medical expenditure, claims and healthcare-utilisation data. Analysing these datasets can help improve visibility into portfolio composition, understand cost patterns and identify customer segments that may require further investigation.

This project examines the available health insurance data to understand how customer characteristics, insurance plans, medical expenditure, claims, recorded health indicators and healthcare utilisation vary across different segments.

The analysis is descriptive and intended to support data-driven business understanding rather than clinical diagnosis or financial profitability assessment.

## 3. Project Objectives

The project has the following objectives:

- Analyse customer demographics and insurance portfolio composition.
- Examine the distribution of customers across different insurance plans and geographical regions.
- Calculate and compare annual medical expenditure, premiums and claims.
- Identify variations in healthcare costs across insurance plans and customer segments.
- Analyse recorded health-risk indicators and chronic-condition patterns.
- Examine healthcare utilisation and medical procedure volumes.
- Perform customer segmentation and plan-level comparisons using SQL.
- Develop interactive Power BI dashboards to communicate key findings.
- Generate data-supported observations that may help guide further business investigation.

## 4. Dataset Information

| Attribute | Details |
|---|---|
| Dataset | Health Insurance Customer Dataset |
| Domain | Healthcare & Insurance Analytics |
| Records | 100,000 |
| Columns | 54 |
| Data Format | CSV |
| Analysis Level | Customer-level |
| Database | MySQL |

The dataset contains information relating to:

- Customer demographics
- Insurance plans and regions
- Annual medical costs and premiums
- Claims and claims-related metrics
- Health indicators and chronic conditions
- Healthcare utilisation
- Medical procedures
- Recorded risk indicators

**Data-quality observation:** The `alcohol_freq` column contains 30,083 missing values, representing approximately 30.083% of the dataset.

The analysis considers the available fields and their data-quality limitations when interpreting results.

## 5. Tools & Technologies

- **Python:** Data inspection, cleaning and exploratory data analysis.
- **Pandas & NumPy:** Data manipulation and numerical analysis.
- **Matplotlib & Seaborn:** Data visualisation.
- **Jupyter Notebook:** Python analysis environment.
- **MySQL:** Database management and business-query analysis.
- **Microsoft Excel:** Dataset inspection and supporting analysis.
- **Power Query:** Data transformation and reshaping.
- **Power BI:** Interactive dashboard development.

## 6. Project Workflow

The project follows a structured end-to-end data analytics process.

### A. Python – Exploratory Data Analysis (EDA)

- Loaded and inspected the customer-level dataset.
- Examined dataset dimensions, column names and data types.
- Performed data-quality checks.
- Identified missing values and duplicate records.
- Analysed categorical and numerical variables.
- Explored customer demographics, insurance plans, costs, claims and health-related indicators.
- Examined distributions and potential statistical outliers using exploratory techniques.
- Prepared the data for further analysis.

### B. SQL – Database Analysis

- **Database:** `Health_Insurance_Analytics`
- **Table Name:** `medical_insurance`
- **Database Management System:** MySQL Workbench 8.0 CE

Used MySQL to develop and execute **50 numbered business questions** covering:

- Customer portfolio analysis
- Insurance-plan distribution
- Medical expenditure and premium analysis
- Claims analysis
- Chronic-condition analysis
- Recorded health-risk analysis
- Customer and plan-level comparisons
- Advanced customer segmentation

**SQL concepts demonstrated:**

- Aggregate functions: `COUNT()`, `SUM()`, `AVG()`, `MIN()` and `MAX()`
- `GROUP BY` and `ORDER BY`
- Conditional logic using `CASE`
- `UNION ALL`
- Subqueries
- Common Table Expressions (CTEs)
- Window functions: `DENSE_RANK()`, `NTILE()` and `AVG() OVER (PARTITION BY ...)`

### C. Power BI – Dashboard Development

Developed **three interactive dashboard pages**:

#### Page 1 – Health Insurance Portfolio Overview

- Total customers
- Average customer age
- Average customer income
- Recorded high-risk customer count
- Insurance-plan distribution
- Regional customer distribution
- Residential-category distribution
- Customer age-group analysis

#### Page 2 – Healthcare Costs & Claims Analysis

- Total annual medical cost
- Average annual medical cost
- Total annual premium
- Total claims paid
- Total claims
- Medical expenditure by insurance plan
- Claims paid by insurance plan
- Average claim amount by region
- Premium versus medical-cost comparison

#### Page 3 – Health Risk & Chronic Conditions Analysis

- Average recorded risk score
- Recorded high-risk and non-high-risk customer distribution
- Chronic-condition analysis
- Condition prevalence across recorded risk groups
- Customers with major procedures
- Medical procedure volumes by recorded risk category

## 7. Key Analytical Findings

The analysis generated several observations from the available dataset.

### A. Portfolio Overview

- Total customers analysed: **100,000**.
- Average customer age: **47.52 years**.
- Average customer income: **49,873.91** (currency not verified).
- Customers marked as high-risk: **36,781**.
- PPO and HMO are the two largest insurance-plan groups, with **35,167** and **34,723** customers respectively.
- The South region has the highest customer count, with **28,029** customers.
- Urban customers represent the largest residential category, with **60,019** customers.

### B. Healthcare Costs & Claims

- Total annual medical cost: approximately **300.95 million** in the dashboard.
- Average annual medical cost: **3,009.45**.
- Total annual premium: approximately **58.23 million**.
- Total claims paid: approximately **137.79 million**.
- Total claims: **162,178**.
- PPO and HMO account for the largest displayed aggregate medical expenditure and claims-paid amounts.

### C. Health Risk & Chronic Conditions

- Average recorded risk score: **0.52**.
- Customers marked as high-risk: **36,781 (36.78%)**.
- Customers marked as non-high-risk: **63,219 (63.22%)**.
- Hypertension is the most frequently represented chronic condition, recorded for **20,345** customers.
- Mental health is the second most frequently represented condition, recorded for **13,014** customers.
- Customers marked as having undergone major procedures: **16,970**.
- The dashboard shows higher within-group recorded condition prevalence among customers marked high-risk across the ten analysed conditions.

These are descriptive findings from the supplied dataset and should not be interpreted as evidence of causation or clinical conclusions.

## 8. Key Skills Demonstrated

- Data Cleaning & Preparation
- Exploratory Data Analysis (EDA)
- Data Quality Assessment
- Python Programming
- Pandas & NumPy
- Data Visualisation
- MySQL & Advanced SQL
- Business Question Development
- Customer Segmentation
- Window Functions & CTEs
- Power Query
- Power BI Dashboard Development
- Data Interpretation
- Business Insights & Reporting

## 9. Conclusion

The Health Insurance Portfolio, Cost & Risk Analytics project demonstrates an end-to-end data analytics workflow using Python, MySQL and Power BI.

By analysing 100,000 customer records, developing 50 SQL business questions and building three interactive dashboard pages, the project explores insurance portfolio composition, healthcare expenditure, premiums, claims, recorded health-risk indicators, chronic conditions and healthcare utilisation.

The combination of Python-based exploratory analysis, SQL-driven business analysis and Power BI visualisation provides a structured understanding of the available data and highlights areas that may warrant further business investigation.

The project demonstrates practical skills in data preparation, exploratory analysis, database querying, customer segmentation, dashboard development and business insight communication.