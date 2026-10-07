USE pnl;
			-- FINANCIAL VALIDATION 
            
-- Q: Do the indepedent totals of revenue, EBITDA and net profit reconcile?
SELECT COUNT(*) AS valid_fin_calc FROM pl_dataset 
WHERE 	ABS((gross_profit-(revenue-cogs))) < 0.01
	AND ABS((ebitda -(revenue- cogs- operating_expense))) <0.01
    AND ABS((net_profit-(revenue-cogs-operating_expense-interest-tax)))<0.01;
-- INSIGHT: There is no miscalculated gross profit, EBITDA, net profit


-- Q: Are there any records where EBITDA exceeds Gross Profit?
SELECT COUNT(*) AS invalid_ebitda FROM pl_dataset
WHERE ebitda>gross_profit;
-- INSIGHT: There is no EBITDA that crosses Gross profit


-- Q: Are there any transactions that has higher COGS than revenue? 
SELECT COUNT(*) FROM pl_dataset
WHERE pl_dataset.cogs > pl_dataset.revenue;
-- INSIGHTS: Gross profit is either 0 or positive 
-- 			No items were sold at loss 


-- Q: What are the total revenue, costs and profits across all transactions?
SELECT 
	ROUND(SUM(revenue)/1000000,2) AS total_revenue_md,
    ROUND(SUM(cogs)/1000000,2) AS total_cogs_md,
    ROUND(SUM(gross_profit)/1000000,2) AS total_gross_profit_md,
    ROUND(SUM(operating_expense)/1000000,2) AS total_opex_md,
    ROUND(SUM(ebitda)/1000000,2) AS total_ebitda_md,
    ROUND(SUM(interest)/1000000,2) AS total_interest_md,
    ROUND(SUM(tax)/1000000,2) AS total_tax_md,
    ROUND(SUM(net_profit)/1000000,2) AS total_net_profit_md
FROM pl_dataset;
-- INSIGHTS: COGS has the represents the largest deduction from revenue 
-- 			 followed by Operating Expenses


-- Q: Do the combined totals reconcile?
SELECT
    SUM(revenue) - SUM(cogs) AS gross_profit_calc,
    SUM(gross_profit) AS gross_profit_stored,
    SUM(revenue) - SUM(cogs) - SUM(operating_expense) AS ebitda_calc,
    SUM(ebitda) AS ebitda_stored,
    SUM(revenue) - SUM(cogs) - SUM(operating_expense) - SUM(interest) - SUM(tax) AS net_profit_calc,
    SUM(net_profit) AS net_profit_stored
FROM pl_dataset;
-- INSIGHT: Combined gross profit, EBITDA and net profit each equal their calculated values


-- Q: Are there any transactions with negative financial values? 
SELECT 
	SUM(CASE WHEN revenue<0 THEN 1 ELSE 0 END) 
		AS neg_revenue,
	SUM(CASE WHEN cogs<0 THEN 1 ELSE 0 END) 
		AS neg_cogs,
	SUM(CASE WHEN operating_expense<0 THEN 1 ELSE 0 END) 
		AS neg_opex,
	SUM(CASE WHEN interest<0 THEN 1 ELSE 0 END) 
		AS neg_interest,
	SUM(CASE WHEN tax<0 THEN 1 ELSE 0 END) 
		AS neg_tax,
	SUM(CASE WHEN gross_profit<0 THEN 1 ELSE 0 END) 
		AS neg_gross_profit,
	SUM(CASE WHEN ebitda<0 THEN 1 ELSE 0 END) 
		AS neg_ebitda,
	SUM(CASE WHEN net_profit<0 THEN 1 ELSE 0 END) 
		AS neg_net_profit
FROM pl_dataset;
-- INSIGHTS: Every Revenue, cogs, opex, interest and net gross profit is non negative 
-- 			Identified negative values in Tax (26), EBITDA (23), and Net Profit (26)
-- 			The 26 loss-making transactions require further investigative analysis


-- Q: Are the transactions with negative tax and the transactions with negative net profit same? 
SELECT COUNT(*) AS neg_net_profit_neg_tax
FROM pl_dataset
WHERE tax<0 AND net_profit<0;
-- INSIGHTS: Negative tax is probably the outcome of negative profit 


-- Q: Are the transactions with negative profit and the transactions with positive EBITDA same?
SELECT COUNT(*) AS neg_net_profit_pos_EBITDA
FROM pl_dataset
WHERE net_profit<0 AND ebitda>0;
-- INSIGHTS: 26 Transactions that has negative net profit out of them 3 has positive EBITDA 
-- 			 The interest for these 3 trnsaction must be evaluated 


-- Q: What are the interest of 3 transactions that has negative net profit yet positive EBITDA?
SELECT transactionid,ebitda,interest,net_profit,tax, interest-ebitda AS interest_exceeds_ebitda_by
FROM pl_dataset
WHERE ebitda>0 AND net_profit<0;
-- INSIGHTS: Even after the tax credit the interest turned 3 profitable business into loss
-- 			 These loss-making rows are not caused by weak operations
-- 			 Carried forward to the profit leakage analysis

