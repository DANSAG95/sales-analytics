WITH joined_tables AS (
    SELECT
	    c.country,
	    p.category,
        s.quantity * p.unit_price_usd AS revenue,
        s.quantity * p.unit_cost_usd AS cost
    FROM analytics.sales AS s
    LEFT JOIN analytics.products AS p
        ON s.product_key = p.product_key
	LEFT JOIN analytics.customers AS c
ON s.customer_key = c.customer_key
),
rank_category AS (
     SELECT 
	     jt.country,
         jt.category,
	     jt.profit,
	     RANK() OVER(PARTITION BY jt.country ORDER BY jt.profit DESC) AS rank   
FROM (SELECT country,
    category,
    SUM(revenue - cost) AS profit 
	FROM joined_tables
GROUP BY country, category) AS jt)
SELECT *
FROM rank_category
WHERE rank = 1
ORDER BY profit DESC;