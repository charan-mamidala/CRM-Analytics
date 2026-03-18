select * from account_table;
select * from lead_data;
select * from opportunity_product;
select * from opportunity_table;
select * from user_table;
select * from user_table_modified;

-- alter table account_table rename column `account id` to account_id;
/* Forecasted Amount */

SELECT SUM(expected_amount) AS Forecasted_Amount
FROM opportunity_table;

/* Date Fields */

SELECT 
YEAR(STR_TO_DATE(created_date,'%m/%d/%Y')) AS Year
FROM opportunity_table;

/* Month Full Name */

SELECT 
MONTHNAME(STR_TO_DATE(created_date,'%m/%d/%Y')) AS MonthFullName
FROM opportunity_table;

/* Quarter */

SELECT 
QUARTER(STR_TO_DATE(created_date,'%m/%d/%Y')) AS Quarter
FROM opportunity_table;

/* Year Month */

SELECT 
DATE_FORMAT(STR_TO_DATE(created_date,'%d/%m/%Y'),'%Y/%b') AS YearMonth
FROM opportunity_table;

/* Active Opportunities */

SELECT COUNT(*) AS Active_Opportunities
FROM opportunity_table
WHERE stage NOT IN ('Closed Won','Closed Lost');

/* Conversion Rate */

SELECT 
COUNT(CASE WHEN stage='Closed Won' THEN 1 END) * 100 /
COUNT(*) AS Conversion_Rate
FROM opportunity_table;

/* Win Rate */

SELECT 
COUNT(CASE WHEN stage='Closed Won' THEN 1 END) * 100 /
COUNT(CASE WHEN stage IN ('Closed Won','Closed Lost') THEN 1 END) 
AS Win_Rate
FROM opportunity_table;

/* Loss Rate */

SELECT 
COUNT(CASE WHEN stage='Closed Lost' THEN 1 END) * 100 /
COUNT(*) AS Loss_Rate
FROM opportunity_table;

/* OPPORTUNITY */
/* Opportunities by Industry */

SELECT industry,
COUNT(*) AS Total_Opportunities
FROM opportunity_table
GROUP BY industry;

/* Expected Amount by Industry */

SELECT industry,
SUM(Expected_Amount) AS Expected_Amount
FROM opportunity_table
GROUP BY industry;

/* Active vs Total Opportunities */

SELECT 
DATE_FORMAT(STR_TO_DATE(created_date,'%m/%d/%Y'),'%m') AS Month,
COUNT(*) AS Total_Opportunities,
COUNT(CASE WHEN stage NOT IN ('Closed Won','Closed Lost') THEN 1 END) AS Active_Opportunities
FROM opportunity_table
GROUP BY Month
ORDER BY Month;

/* Expected vs Amount */

SELECT 
DATE_FORMAT(STR_TO_DATE(created_date,'%m/%d/%Y'),'%m') AS Month,
SUM(expected_amount) AS Expected_Amount,
SUM(amount) AS Amount
FROM opportunity_table
GROUP BY Month
ORDER BY Month;


/* Monthly Revenue & Opportunity */

SELECT 
DATE_FORMAT(STR_TO_DATE(close_date,'%m/%d/%Y'),'%Y-%m') AS Month,
SUM(amount) AS Revenue,
COUNT(*) AS Opportunities
FROM opportunity_table
GROUP BY Month
ORDER BY Month;

/* Yearly Trend */

SELECT 
YEAR(STR_TO_DATE(created_date,'%m/%d/%Y')) AS Year,
COUNT(*) AS Opportunities
FROM opportunity_table
GROUP BY Year
ORDER BY Year;

/* LEAD */
/* Quarterly Distribution */

SELECT 
QUARTER(STR_TO_DATE(a.created_date,'%m/%d/%Y')) AS Quarter,
COUNT(*) AS Total_Leads
FROM lead_data l
JOIN account_table a
ON l.converted_account_id = a.account_id
GROUP BY Quarter
ORDER BY Quarter;

-- ALTER TABLE lead_data
-- RENAME COLUMN `converted account id` TO converted_account_id;

/* Monthly Trend */

SELECT 
DATE_FORMAT(STR_TO_DATE(a.created_date,'%m/%d/%Y'),'%m') AS Month,
COUNT(*) AS Leads
FROM lead_data l
JOIN account_table a
ON l.converted_account_id = a.account_id
GROUP BY Month
ORDER BY Month;

-- ALTER TABLE lead_data
-- RENAME COLUMN `lead source` TO lead_source;

/* Lead by Source */

SELECT 
lead_source,
COUNT(*) AS Total_Leads
FROM lead_data
GROUP BY lead_source
ORDER BY Total_Leads DESC;

/* Lead by Industry */

SELECT 
a.industry,
COUNT(*) AS Total_Leads
FROM lead_data l
JOIN account_table a
ON l.converted_account_id = a.account_id
GROUP BY a.industry
ORDER BY Total_Leads DESC;

/* Converted vs Lost */

SELECT 
status,
COUNT(*) AS Total
FROM lead_data
GROUP BY status;