WITH joined_tables AS (
    SELECT
	    c.country,
	    p.product_name,
		P.category,
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
         jt.product_name,
		 jt.category,
	     jt.profit,
	     RANK() OVER(PARTITION BY jt.country ORDER BY jt.profit DESC) AS rank   
FROM (SELECT country,
    product_name,
	category,
    SUM(revenue - cost) AS profit 
	FROM joined_tables
GROUP BY country, product_name, category) AS jt)
SELECT *
FROM rank_category
WHERE rank BETWEEN 1 AND 3
ORDER BY profit DESC;