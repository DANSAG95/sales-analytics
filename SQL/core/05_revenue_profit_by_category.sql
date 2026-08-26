WITH joined_tables AS (
    SELECT
        p.category,
        s.quantity,
        s.quantity * p.unit_price_usd AS revenue,
        s.quantity * p.unit_cost_usd AS cost
    FROM analytics.sales AS s
    LEFT JOIN analytics.products AS p
        ON s.product_key = p.product_key
)

SELECT
    category,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS total_revenue,
    SUM(cost) AS total_cost,
    SUM(revenue - cost) AS total_profit,
    ROUND(
        SUM(revenue - cost) / SUM(revenue) * 100,
        2
    ) AS profit_margin
FROM joined_tables
GROUP BY category
ORDER BY total_profit DESC;