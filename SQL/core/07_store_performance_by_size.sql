WITH store_performance AS (
    SELECT
        st.store_key,
        CASE
            WHEN st.square_meters < 500 THEN 'Small'
            WHEN st.square_meters < 1000 THEN 'Medium'
            ELSE 'Big'
        END AS size_category,
        SUM(s.quantity * p.unit_price_usd) AS revenue,
        SUM(s.quantity * p.unit_cost_usd) AS cost,
        SUM(s.quantity * p.unit_price_usd)
            - SUM(s.quantity * p.unit_cost_usd) AS profit
    FROM analytics.stores AS st
    LEFT JOIN analytics.sales AS s
        ON st.store_key = s.store_key
    LEFT JOIN analytics.products AS p
        ON s.product_key = p.product_key
    WHERE st.store_key <> 0
    GROUP BY st.store_key, st.square_meters
)

SELECT
    size_category,
    COUNT(store_key) AS number_of_stores,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_store,
    ROUND(AVG(profit), 2) AS avg_profit_per_store,
    ROUND(AVG(profit / NULLIF(revenue, 0)) * 100, 2) AS avg_profit_margin
FROM store_performance
GROUP BY size_category
ORDER BY avg_profit_per_store DESC;