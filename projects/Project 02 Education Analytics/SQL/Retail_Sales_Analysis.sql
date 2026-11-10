SELECT COUNT(*) AS total_records
FROM retail_sales_db.retail_sales;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT OrderID) AS unique_orders,
    COUNT(*) - COUNT(DISTINCT OrderID) AS duplicate_orders
FROM retail_sales_db.retail_sales;\

SELECT
    SUM(CASE WHEN CustomerName IS NULL OR TRIM(CustomerName) = '' THEN 1 ELSE 0 END) AS missing_customer_names,
    SUM(CASE WHEN PaymentMode IS NULL OR TRIM(PaymentMode) = '' THEN 1 ELSE 0 END) AS missing_payment_modes,
    SUM(CASE WHEN OrderDate IS NULL OR TRIM(OrderDate) = '' THEN 1 ELSE 0 END) AS missing_order_dates
FROM retail_sales_db.retail_sales;

ALTER TABLE retail_sales_db.retail_sales
ADD COLUMN Order_Date DATE;

UPDATE retail_sales_db.retail_sales
SET Order_Date = STR_TO_DATE(OrderDate, '%c/%e/%Y');

SELECT OrderDate, Order_Date
FROM retail_sales_db.retail_sales
LIMIT 10;

SELECT
    COUNT(*) AS total_records,
    COUNT(Order_Date) AS valid_dates,
    MIN(Order_Date) AS first_order_date,
    MAX(Order_Date) AS last_order_date
FROM retail_sales_db.retail_sales;

SELECT
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT OrderID) AS Total_Orders,
    COUNT(DISTINCT CustomerID) AS Unique_Customers,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Sales) / COUNT(DISTINCT OrderID), 2) AS Average_Order_Value
FROM retail_sales_db.retail_sales;

SELECT
    Category,
    COUNT(*) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin_Percent
FROM retail_sales_db.retail_sales
GROUP BY Category
ORDER BY Total_Revenue DESC;

SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Sales_Month,
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(*) AS Total_Orders
FROM retail_sales_db.retail_sales
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date),
    MONTHNAME(Order_Date)
ORDER BY
    Sales_Year,
    Sales_Month;
    
SELECT
    MONTHNAME(Order_Date) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM retail_sales_db.retail_sales
GROUP BY MONTH(Order_Date), MONTHNAME(Order_Date)
ORDER BY Total_Revenue DESC;

SELECT
    City,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin_Percent
FROM retail_sales_db.retail_sales
GROUP BY City
ORDER BY Total_Revenue DESC;

SELECT
    ProductID,
    ProductName,
    Category,
    SUM(Quantity) AS Total_Quantity_Sold,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM retail_sales_db.retail_sales
GROUP BY ProductID, ProductName, Category
ORDER BY Total_Revenue DESC
LIMIT 10;

SELECT
    PaymentMode,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM retail_sales_db.retail_sales),
        2
    ) AS Order_Percentage
FROM retail_sales_db.retail_sales
GROUP BY PaymentMode
ORDER BY Total_Revenue DESC;

SELECT
    SalesChannel,
    COUNT(*) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) / SUM(Sales) * 100,
        2
    ) AS Profit_Margin_Percent
FROM retail_sales_db.retail_sales
GROUP BY SalesChannel
ORDER BY Total_Revenue DESC;

SELECT
    DiscountPct,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(DiscountPct), 2) AS Average_Discount
FROM retail_sales_db.retail_sales
GROUP BY DiscountPct
ORDER BY DiscountPct;