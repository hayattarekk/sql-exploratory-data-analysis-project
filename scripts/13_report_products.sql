
CREATE OR ALTER VIEW gold.report_products AS

WITH base_query AS (
    /*
    -----------------------------------------------------------------------------
    1) Base Query: Retrieves core columns from fact_sales and dim_products
    -----------------------------------------------------------------------------
    */
    SELECT
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost

    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregations AS (
    /*
    -----------------------------------------------------------------------------
    2) Product Aggregations: Summarizes key metrics at the product level
    -----------------------------------------------------------------------------
    */
    SELECT
        product_key,
        product_name,
        category,
        subcategory,

        -- Product cost
        ROUND(CAST(cost AS FLOAT), 2) AS cost,

        -- Product lifespan in months
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,

        -- Most recent sale date
        MAX(order_date) AS last_sale_date,

        -- Total number of unique orders
        COUNT(DISTINCT order_number) AS total_orders,

        -- Total number of unique customers
        COUNT(DISTINCT customer_key) AS total_customers,

        -- Total sales
        ROUND(SUM(CAST(sales_amount AS FLOAT)), 2) AS total_sales,

        -- Total quantity sold
        SUM(quantity) AS total_quantity,

        -- Average Selling Price
        ROUND(
            SUM(CAST(sales_amount AS FLOAT))
            / NULLIF(SUM(quantity), 0),
            2
        ) AS avg_selling_price

    FROM base_query

    GROUP BY
        product_key,
        product_name,
        category,
        subcategory,
        cost
)

-- 3) Final Query: Combines all product results into one output
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,

    last_sale_date,

    -- Recency in months
    DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,

    -- Product Performance Segment
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,

    lifespan,

    total_orders,

    -- Total Sales
    ROUND(total_sales, 2) AS total_sales,

    total_quantity,

    total_customers,

    -- Average Selling Price
    ROUND(avg_selling_price, 2) AS avg_selling_price,

    -- Average Order Revenue (AOR)
    ROUND(
        CASE
            WHEN total_orders = 0 THEN 0
            ELSE CAST(total_sales AS FLOAT) / total_orders
        END,
        2
    ) AS avg_order_revenue,

    -- Average Monthly Revenue
    ROUND(
        CASE
            WHEN lifespan = 0 THEN total_sales
            ELSE CAST(total_sales AS FLOAT) / lifespan
        END,
        2
    ) AS avg_monthly_revenue

FROM product_aggregations;


