-- 01_data_validation.sql

USE pnl;

		-- DATA VALIDATION 

SELECT * FROM pl_dataset LIMIT 10;


-- Q: what are the columns? What are the data types?  
DESCRIBE pl_dataset; 
-- INSIGHTS: Transaction id, date , tax , revenue etc.
-- 			 Numerical columns are int or double 


-- Q: How many total rows are there?
SELECT COUNT(*) AS num_rows 
FROM pl_dataset;
-- INSIGHTS: 499 total rows  


-- Q: Are there NULL values in any column?
SELECT
    COUNT(*) AS total_rows,
    SUM(transactionid IS NULL)      AS null_transactionid,
    SUM(`date` IS NULL)             AS null_date,
    SUM(region IS NULL)             AS null_region,
    SUM(product IS NULL)            AS null_product,
    SUM(business_unit IS NULL)      AS null_business_unit,
    SUM(customer IS NULL)           AS null_customer,
    SUM(revenue IS NULL)            AS null_revenue,
    SUM(cogs IS NULL)               AS null_cogs,
    SUM(gross_profit IS NULL)       AS null_gross_profit,
    SUM(operating_expense IS NULL)  AS null_opex,
    SUM(ebitda IS NULL)             AS null_ebitda,
    SUM(interest IS NULL)           AS null_interest,
    SUM(tax IS NULL)                AS null_tax,
    SUM(net_profit IS NULL)         AS null_net_profit
FROM pl_dataset;
-- INSIGHT: No NULL values in any of the 14 columns across 499 rows


-- Q: How many unique transactions are there?
SELECT COUNT(DISTINCT transactionid) AS unique_transactions FROM pl_dataset;
-- INSIGHTS:499 rows, No duplicate transactions recorded


-- Q: Are there unexpected regions/products/business units?
SELECT region, COUNT(*) AS transactions
FROM pl_dataset
GROUP BY region
ORDER BY transactions DESC;

SELECT product, COUNT(*) AS transactions
FROM pl_dataset
GROUP BY product
ORDER BY transactions DESC;

SELECT business_unit, COUNT(*) AS transactions
FROM pl_dataset
GROUP BY business_unit
ORDER BY transactions DESC;
-- INSIGHTS: No unexpected category values were identified from the dataset structure


-- Q: How many distinct regions, products and business units are there?
SELECT 	COUNT(DISTINCT region) AS regions,
		COUNT(DISTINCT product) AS products,
        COUNT(DISTINCT business_unit) AS business_units
FROM pl_dataset;
-- INSIGHTS: The dataset has 4 regions, 20 products and 4 business units.


-- Q: Are any transactions duplicated under different IDs?
SELECT date,region,product,business_unit,revenue,cogs,COUNT(*) AS num
FROM pl_dataset
GROUP BY date,region,product,business_unit,revenue,cogs
HAVING COUNT(*)>1;
-- INSIGHTS: No repeated records were found for the selected transaction attributes


-- Q: What date range does the data cover?
SELECT MIN(`date`) AS first_date, MAX(`date`) AS last_date
FROM pl_dataset;
-- INSIGHTS: Transactions recorded from 2024-07-15	to 2025-06-15
-- 			 Spanning 12 calendar months (July 2024 to June 2025)

