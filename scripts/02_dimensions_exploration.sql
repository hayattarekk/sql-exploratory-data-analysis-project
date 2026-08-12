SELECT DISTINCT country
FROM gold.dim_customers

SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products

SELECT 
	MIN(order_date) first_order_date,
	Max(order_date) last_order_date,
	DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales

SELECT 
	MIN(birthdate) oldest_birthdate,
	DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
	Max(birthdate) youngest_birthdate,
	DATEDIFF(year, MAX(birthdate),GETDATE()) AS youngest_age
FROM gold.dim_customers
