-- 03_pnl_overview.sql
-- Note: "m" means millions of units; the source states no currency
-- 						PROFIT AND LOSS OVERVIEW
USE pnl;


-- Q: What are the total revenue, costs and profits across all transactions?
SELECT 
	ROUND(SUM(revenue)/1000000,2) AS total_revenue_m,
    ROUND(SUM(cogs)/1000000,2) AS total_cogs_m,
    ROUND(SUM(gross_profit)/1000000,2) AS total_gross_profit_m,
    ROUND(SUM(operating_expense)/1000000,2) AS total_opex_m,
    ROUND(SUM(ebitda)/1000000,2) AS total_ebitda_m,
    ROUND(SUM(interest)/1000000,2) AS total_interest_m,
    ROUND(SUM(tax)/1000000,2) AS total_tax_m,
    ROUND(SUM(net_profit)/1000000,2) AS total_net_profit_m
FROM pl_dataset;
		-- Already calculated in FILE 02_financial_validation.sql
-- INSIGHTS: Combined revenue = 149.16 (Million Unit)
-- 			 Combined COGS = 85.79 (Million Unit)
-- 			 Combined Gross profit = 63.37 (Million Unit)
-- 			 Combined Operating expense = 29.78 (Million Unit) 
-- 			 Combined EBITDA = 33.59 (Million Unit)
-- 			 Combined Net profit = 25.10 (Million Unit)


-- Q: What are the margins for each transaction?
SELECT 
		transactionid,date,region,product,business_unit,
        customer,revenue,cogs,operating_expense,interest,
        tax,year,gross_profit,ebitda,net_profit,
        ROUND(((gross_profit/revenue)*100),2) AS gross_profit_margin_pct,
        ROUND(((ebitda/revenue)*100),2) AS ebitda_margin_pct,
        ROUND(((net_profit/revenue)*100),2) AS net_profit_margin_pct,
        
        ROUND(((cogs/revenue)*100),2) AS cogs_pct,
		ROUND(((operating_expense/revenue)*100),2) AS operating_expense_pct,
		ROUND(((interest/revenue)*100),2) AS interest_pct,
		ROUND(((tax/revenue)*100),2) AS tax_pct
FROM pl_dataset
ORDER BY net_profit_margin_pct DESC LIMIT 20;


-- INSIGHTS: For each transaction how much perrcentage of revenue COGS, OpEx, Interest and Tax takes is calculated


-- Q: Does any transaction have zero revenue?
SELECT COUNT(*) AS zero_revenue 
FROM pl_dataset 
WHERE revenue = 0;
-- INSIGHTS:  No transaction has zero or negative revenue, so margins are defined for all 499 rows

-- Confirming if we needed net_profit_margin in percentage
SELECT net_profit_margin FROM pl_dataset
ORDER BY net_profit_margin DESC;
-- INSIGHTS: Net profit calculated in percentage 
-- 			 Need to be further investigated with respect to net profit margin


-- Q: What are the combined margin percentages ?
SELECT
	Round((SUM(gross_profit)/SUM(revenue)*100),2) AS comb_gross_margin_pct,
    Round((SUM(ebitda)/SUM(revenue)*100),2) AS comb_ebitda_margin_pct,
    Round((SUM(net_profit)/SUM(revenue)*100),2) AS comb_profit_margin_pct
FROM pl_dataset;
-- INSIGHTS : 	The combined Gross margin(%) is 42.49%
-- 				The combined EBITDA margin(%) is 22.52%
-- 				The combined net profit margin(%) is 16.83%
-- About 17 units of each 100 units revenue reach net profit


-- Q: How much of every 100 units of revenue does each cost take?
SELECT 
    ROUND((SUM(cogs) / SUM(revenue) * 100), 2) AS cogs_pct,
    ROUND((SUM(operating_expense) / SUM(revenue) * 100),
            2) AS operating_expense_pct,
    ROUND((SUM(interest) / SUM(revenue) * 100), 2) AS interest_pct,
    ROUND((SUM(tax) / SUM(revenue) * 100), 2) AS tax_pct
FROM
    pl_dataset;

-- INSIGHTS : For combined analysis
-- 				COGS takes 57.51% of revenue
-- 				OpEx takes 19.97% of revenue
-- 				Interest takes 1.49% of revenue
-- 				Tax takes 4.21% of revenue
-- 				COGS takes the most of the revenue 
-- 				The primary cost category to investigate for potential

-- Q: What is the average revenue, COGS and net profit per transactions?
SELECT 
		COUNT(*) AS num_transactions,
        ROUND(AVG(revenue),2) AS avg_revenue,
        ROUND(AVG(cogs),2) AS avg_cogs,
        ROUND(AVG(gross_profit),2) AS avg_gross_profit,
        ROUND(AVG(ebitda),2) AS avg_ebitda,
        ROUND(AVG(net_profit),2) AS avg_net_profit
FROM pl_dataset;
-- INSIGTHS: 
-- 				The average revenue is 298913.18
-- 				The average COGS is 171915.07
-- 				The average gross profit is 126998.11
-- 				The average EBITDA is 67319.26
-- 				The average net profit is 50295.07


-- Q: How much does each stage of the P&L consume?
SELECT 
		ROUND(100*(SUM(operating_expense)/SUM(gross_profit)),2) AS opex_pct_of_gross_profit,
        ROUND(100*((SUM(interest)+SUM(tax))/SUM(ebitda)),2) AS interest_tax_pct_of_ebitda
FROM pl_dataset;
-- INSIGTHS: 
-- 				Operating expense consumes about 47% of gross profit 
--              Interest and tax together take about 25% of EBITDA


-- Q: What overall tax rate applies to pre-tax profit (EBITDA - interest)?
SELECT
    ROUND(100 * SUM(tax) / (SUM(ebitda) - SUM(interest)), 2) AS combined_tax_rate_pct
FROM pl_dataset;
-- INSIGHTS: Combined tax is about 20.0% of pre-tax profit.


