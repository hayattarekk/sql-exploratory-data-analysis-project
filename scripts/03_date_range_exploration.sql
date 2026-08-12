/*
-- Find Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Find the average selling price
SELECT AVG(sls_price) AS avg_price FROM gold.fact_sales

-- Find total number of orders
--SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find total numbers of products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products

-- Find total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Find total number of customers that has placed an  order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;
*/

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' , SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' , AVG(sls_price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders' , COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products' , COUNT(product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total Nr. Customers' , COUNT(DISTINCT customer_key) FROM gold.fact_sales






