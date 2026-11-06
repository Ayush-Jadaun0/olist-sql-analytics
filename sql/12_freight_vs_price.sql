-- Q12: Which categories have the highest shipping cost relative to item price?
SELECT COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
       COUNT(*) AS items,
       ROUND(AVG(i.price), 2)         AS avg_price,
       ROUND(AVG(i.freight_value), 2) AS avg_freight,
       ROUND(100.0 * SUM(i.freight_value) / SUM(i.price), 1) AS freight_pct_of_price
FROM order_items i
JOIN products p ON p.product_id = i.product_id
LEFT JOIN product_category_name_translation t ON t.product_category_name = p.product_category_name
GROUP BY category
HAVING items >= 200
ORDER BY freight_pct_of_price DESC
LIMIT 10;
