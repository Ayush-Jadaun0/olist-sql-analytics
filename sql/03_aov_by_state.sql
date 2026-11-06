-- Q3: What is the average order value in each customer state?
WITH order_totals AS (
  SELECT o.order_id, o.customer_id, SUM(i.price) AS order_value
  FROM orders o
  JOIN order_items i ON i.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY o.order_id, o.customer_id
)
SELECT c.customer_state AS state,
       COUNT(*)                     AS orders,
       ROUND(AVG(ot.order_value),2) AS avg_order_value
FROM order_totals ot
JOIN customers c ON c.customer_id = ot.customer_id
GROUP BY state
HAVING orders >= 100
ORDER BY avg_order_value DESC;
