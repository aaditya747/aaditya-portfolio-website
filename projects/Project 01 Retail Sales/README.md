# Retail Sales Analysis

**Author:** Aaditya Mahajan\
**Project type:** Independent data analytics portfolio project\
**Dataset:** Synthetic retail transaction data

## Project Overview

This project analyzes 5,000 retail transactions from 2025 to understand
sales performance, profitability, product and category performance,
customer activity, payment preferences, sales channels, and discount
levels.

It demonstrates an end-to-end analytics workflow using Excel Power Query
for data preparation, MySQL for querying and analysis, and Power BI for
interactive reporting.

> **Data note:** This is a synthetic dataset created for learning and
> portfolio demonstration. It does not represent a real company or real
> customer transactions.

## Objectives

-   Measure revenue, profit, order volume, quantity sold, and average
    order value.
-   Compare performance across product categories and cities.
-   Identify high-performing products.
-   Explore monthly sales trends.
-   Understand payment-mode and sales-channel performance.
-   Examine revenue and profit across discount levels.
-   Present findings in an interactive Power BI dashboard.

## Tools and Technologies

  -----------------------------------------------------------------------
  Tool                                Purpose
  ----------------------------------- -----------------------------------
  Microsoft Excel -- Power Query      Data profiling, cleaning, and
                                      standardization

  MySQL Workbench                     Data import, validation,
                                      aggregation, and SQL analysis

  Microsoft Power BI                  Interactive dashboard and
                                      visualization
  -----------------------------------------------------------------------

## Dataset

The dataset contains **5,000 transaction records** covering January to
December 2025.

  Attribute                                Value
  --------------------- ------------------------
  Transaction records                      5,000
  Unique order IDs                         5,000
  Unique customers                           500
  Products                                   100
  Cities                                      10
  Reporting period        January--December 2025

Fields include order dates, customer details, city and state, product
information, quantity, unit price and cost, discount percentage, sales,
cost, profit, payment mode, and sales channel.

## Data Preparation

Excel Power Query was used to inspect and prepare the dataset. Work
included:

-   Profiling columns to identify missing or blank values.
-   Replacing missing customer names and payment modes with `Unknown`.
-   Trimming and cleaning text fields such as city and category.
-   Standardizing category capitalization.
-   Reviewing column data types.
-   Checking order IDs for duplicates and dates for validity.

The original raw dataset was retained separately from the prepared data.

## SQL Analysis

The dataset was imported into MySQL and analyzed using SQL queries. The
analysis covered:

1.  Overall business KPIs
2.  Duplicate order checks and date validation
3.  Revenue and profit by category
4.  Monthly revenue and profit trends
5.  City-level performance
6.  Product-level performance
7.  Payment-mode analysis
8.  Online versus store sales
9.  Discount-level analysis

The SQL queries are available in
[`SQL/Retail_Sales_Analysis.sql`](SQL/Retail_Sales_Analysis.sql).

## Selected Results and Insights

These figures were returned by the SQL analysis of the project dataset.

  Metric                          Result
  --------------------- ----------------
  Total revenue           ₹41,949,595.29
  Total profit            ₹13,726,902.31
  Total orders                     5,000
  Unique customers                   500
  Total quantity sold             11,854
  Average order value          ₹8,389.92

### Category performance

-   Furniture recorded the highest category revenue and profit in the
    category analysis.
-   Electronics was the second-largest category by revenue.
-   Accessories and Stationery contributed smaller shares of revenue.

### Sales channel performance

-   Online: revenue of ₹23,942,766.57 and profit of ₹7,780,505.86.
-   Store: revenue of ₹18,006,828.72 and profit of ₹5,946,396.45.
-   Online generated more revenue, while Store had a slightly higher
    profit margin (33.02% compared with 32.50%).

### Discount analysis

-   Orders with no discount generated the highest total profit:
    ₹5,157,300.40.
-   The 25% discount group generated the lowest total profit among the
    discount groups: ₹187,496.92.
-   These are group-level comparisons; they do not by themselves prove
    that discounts caused the differences.

## Power BI Dashboard

An interactive Power BI dashboard was created using the same project CSV
dataset. It provides a visual overview of key performance indicators and
sales trends.

Add the final dashboard screenshots to the `Screenshots` folder. You can
embed a screenshot here once its final filename is known.

## Project Structure

``` text
Project_01_Retail_Sales/
├── Dataset/
│   ├── retail_sales_raw.csv
│   └── Retail_Sales_Cleaned.csv
├── SQL/
│   └── Retail_Sales_Analysis.sql
├── PowerBI/
│   └── [Power BI report file]
├── Documentation/
└── Screenshots/
```

File names may differ depending on the final saved versions. Keep the
raw and cleaned datasets clearly distinguished.

## How to Explore the Project

1.  Review the dataset files in `Dataset/`.
2.  Open `SQL/Retail_Sales_Analysis.sql` in MySQL Workbench and run the
    analysis queries against the imported table.
3.  Open the Power BI report in the `PowerBI/` folder to explore the
    dashboard.
4.  Review screenshots and supporting notes in their respective folders.

## Key Takeaway

This project demonstrates how spreadsheet-based data preparation, SQL
analysis, and Power BI reporting can be combined to turn
transaction-level data into business-focused insights.

## Author

**Aaditya Mahajan**\
Aspiring Data Analyst
