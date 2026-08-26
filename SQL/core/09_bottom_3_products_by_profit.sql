WITH joined_tables AS (
    SELECT
        p.product_name,
        p.category,
        s.quantity * p.unit_price_usd AS revenue,
        s.quantity * p.unit_cost_usd AS cost
    FROM analytics.sales AS s
    LEFT JOIN analytics.products AS p
        ON s.product_key = p.product_key
),

product_profit AS (
    SELECT
        product_name,
        category,
        SUM(revenue - cost) AS total_profit
    FROM joined_tables
    GROUP BY product_name, category
)

SELECT
    product_name,
    category,
    total_profit
FROM product_profit
ORDER BY total_profit ASC
LIMIT 3;