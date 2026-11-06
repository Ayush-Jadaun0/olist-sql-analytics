-- Q2: Which 10 product categories bring in the most revenue?
SELECT COALESCE(t.product_category_name_english, p.product_category_name, 'unknown') AS category,
       COUNT(*)                 AS items_sold,
       ROUND(SUM(i.price), 2)   AS revenue
FROM order_items i
JOIN orders o   ON o.order_id = i.order_id AND o.order_status = 'delivered'
JOIN products p ON p.product_id = i.product_id
LEFT JOIN product_category_name_translation t
       ON t.product_category_name = p.product_category_name
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;
