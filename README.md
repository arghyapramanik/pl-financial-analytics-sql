<div align="center">

# P&L Financial Analytics — SQL Investigation

### Turning 499 transaction-level P&L records into profitability insight, risk signals, and management action points

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-E34F26?style=for-the-badge&logo=databricks&logoColor=white)
![Financial Analytics](https://img.shields.io/badge/Financial%20Analytics-2563EB?style=for-the-badge&logo=quickbooks&logoColor=white)
![Data Validation](https://img.shields.io/badge/Data%20Validation-16A34A?style=for-the-badge&logo=checkmarx&logoColor=white)

![Python](https://img.shields.io/badge/Python-Planned-lightgrey?style=for-the-badge&logo=python&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Planned-lightgrey?style=for-the-badge&logo=powerbi&logoColor=white)
![Status](https://img.shields.io/badge/Status-In%20Progress%20(2%20of%209%20SQL%20phases)-F59E0B?style=for-the-badge)

</div>

---

## The Business Question

> **How can transaction-level financial data show where a business makes money, where it loses it, and which segments management should look at first?**

The project follows the investigation flow below:

```text
Can I trust the data?  →  What happened?  →  Where?  →  Why?  →  How risky?  →  What should management check?
```

This is my financial analytics project, built in public one phase at a time. The README only describes work that is finished.

---

## Dataset at a Glance

| | |
|---|---|
| **Records** | 499 transactions |
| **Period** | 15 Jul 2024 to 15 Jun 2025 (12 months) |
| **Dimensions** | 4 regions · 20 products · 4 business units · 220 customers |
| **Measures** | Revenue, COGS, operating expense, gross profit, EBITDA, interest, tax, net profit |

---

## Headline Financials

Totals across all 499 transactions, in millions (the source does not state a currency).

| Metric | Total (millions) |
|---|---|
| Revenue | 149.16 |
| COGS | 85.79 |
| Gross profit | 63.37 |
| Operating expense | 29.78 |
| EBITDA | 33.59 |
| Interest | 2.22 |
| Tax | 6.27 |
| Net profit | 25.10 |

**Insight:** COGS is the largest deduction from revenue, followed by operating expenses.

---

## Findings So Far

| Finding | Why it matters |
|---|---|
| Profit columns reconcile with their formulas on **all 499 rows** and in total | Every later margin and profit figure can be trusted |
| **26 of 499 transactions (about 5.2%) are loss-making** | These become the starting point of the profit leakage analysis |
| **3 of the 26 losses have positive EBITDA** | Even after the tax credit, interest turned these profitable operations into losses, so the issue is financing, not operations |
| Tax is negative only on the 26 loss-making rows | Consistent with tax following pre-tax profit; to be confirmed in a later phase |
| No duplicates, no NULLs, no COGS above revenue | No cleaning step that could distort the results |

---

## Phases Completed

### Phase 1: Data Validation (`01_data_validation.sql`)
*Question: Can I trust this dataset?*

| Check | Result |
|---|---|
| Total rows vs unique transaction IDs | 499 / 499, no duplicate IDs |
| NULL values | None in any of the 14 columns |
| Duplicates under different IDs | None found |
| Category values (regions, products, business units) | 4 / 20 / 4, no unexpected values |
| Repeat check on date, region, product, business unit, revenue and COGS | No repeated records |
| Customers | 220 (about 2.3 transactions each) |
| Date coverage | 2024-07-15 to 2025-06-15 |

### Phase 2: Financial Validation (`02_financial_validation.sql`)
*Question: Does the financial logic reconcile?*

| Check | Result |
|---|---|
| Gross profit, EBITDA, net profit vs formulas | Match on all 499 transactions |
| Combined totals | Reconcile for gross profit, EBITDA and net profit |
| EBITDA above gross profit / COGS above revenue | None |
| Negative values | Tax (26), EBITDA (23), net profit (26); none in revenue, COGS, operating expense, interest or gross profit |
| Negative tax vs loss-making transactions | All 26 negative-tax rows are the 26 loss-making rows |
| Loss-making with positive EBITDA | 3 rows, where interest exceeds EBITDA |
---

## Tech Stack and Skills

**Used so far**

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![MySQL Workbench](https://img.shields.io/badge/MySQL%20Workbench-00758F?style=flat-square&logo=mysql&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=flat-square&logo=git&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white)

**Skills demonstrated**

![Data Profiling](https://img.shields.io/badge/Data%20Profiling-0EA5E9?style=flat-square)
![Data Validation](https://img.shields.io/badge/Data%20Validation-16A34A?style=flat-square)
![Reconciliation](https://img.shields.io/badge/Financial%20Reconciliation-7C3AED?style=flat-square)
![Conditional Aggregation](https://img.shields.io/badge/Conditional%20Aggregation-EC4899?style=flat-square)
![Duplicate Detection](https://img.shields.io/badge/Duplicate%20Detection-F97316?style=flat-square)
![Date Functions](https://img.shields.io/badge/Date%20Functions-14B8A6?style=flat-square)
![P&L Understanding](https://img.shields.io/badge/P%26L%20Understanding-2563EB?style=flat-square)

**Techniques:** `COUNT / COUNT DISTINCT` · `CASE WHEN` · boolean sums · `GROUP BY / HAVING` · tolerance checks (`ABS(...) < 0.01`) for decimal comparison · date range checks

**Planned**

![Python](https://img.shields.io/badge/Python-Planned-lightgrey?style=flat-square&logo=python&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Planned-lightgrey?style=flat-square&logo=powerbi&logoColor=white)

---

## Project Progress

| # | File | Focus | Status |
|---|---|---|---|
| 1 | `01_data_validation.sql` | Data quality | Done ✅|
| 2 | `02_financial_validation.sql` | Financial reconciliation | Done ✅|
| 3 | `03_pnl_overview.sql` | Overall P&L and margins | Planned ⌛|
| 4 | `04_monthly_growth.sql` | Growth over time | Planned ⌛|
| 5 | `05_segment_performance.sql` | Profit by segment | Planned ⌛|
| 6 | `06_profit_leakage.sql` | Loss-making transactions | Planned ⌛|
| 7 | `07_concentration_risk.sql` | Customer dependence | Planned ⌛|
| 8 | `08_budget_vs_actual.sql` | Budget variance | Planned ⌛|
| 9 | `09_red_flags.sql` | Management action points | Planned ⌛|
| Python | `python/` (file names to be decided) | Python analysis | Not started ⌛|
| Power BI | `powerbi/` (file names to be decided) | Dashboard | Not started ⌛|

Phase descriptions and findings are added here only after each phase is finished.

---

## Repository Structure

```text
pl-financial-analytics-sql/
├── README.md
├── data/
│   └── (dataset file, original name kept)
└── sql/
    ├── 01_data_validation.sql
    └── 02_financial_validation.sql
```

Planned folders (`python/`, `powerbi/`) and further SQL files will be added as each phase is completed.

---

## How to Run

1. Create a database: `CREATE DATABASE pnl;`
2. Import the file from `data/` into a table named `pl_dataset` (for example with the Table Data Import Wizard in MySQL Workbench).
3. Check the column names: `transactionid`, `date`, `region`, `product`, `business_unit`, `customer`, `revenue`, `cogs`, `operating_expense`, `interest`, `tax`, `gross_profit`, `ebitda`, `net_profit`.
4. Run the files in `sql/` in numbered order. Each file opens with the question it answers, and each query has its own question and an insight written from the real output.

---

## Data Limitations

- The source does not say whether the data is real or synthetic, so findings describe this dataset only.
- No currency is stated, so no currency symbol is used.
- 499 transactions over 12 months means no year-over-year comparison, and small segments may be noisy.
- All entities sit in one combined P&L, so margins are weighted averages and can hide weaker segments.

---

## Data Source and Credits

- **Dataset:** Nimesh's [profit-loss-analysis](https://github.com/nimeshpanicker/profit-loss-analysis) repository, included unmodified with the author's permission.
- **Analysis, SQL queries and documentation:** Arghya.

---

<div align="center">

Feedback is welcome. Open an issue or reach out on [LinkedIn](https://www.linkedin.com/in/arghya-pramanik).

</div>
