WITH joined_tables AS (
    SELECT
	    p.product_name,
		p.product_key,
        s.quantity,
        p.unit_price_usd,
        p.unit_cost_usd,
        s.quantity * p.unit_price_usd AS revenue,
        s.quantity * p.unit_cost_usd AS cost
    FROM analytics.sales AS s
    LEFT JOIN analytics.products AS p
        ON s.product_key = p.product_key
)

SELECT
    product_name,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS revenue,
    SUM(cost) AS total_cost,
    SUM(revenue - cost) AS profit,
    ROUND(SUM(revenue - cost) / SUM(revenue) * 100, 2) AS profit_margin
FROM joined_tables
GROUP BY product_name, product_key
ORDER BY revenue DESC
LIMIT 10;