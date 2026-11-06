-- Q5: Who are the top 10 customers by lifetime spend?
WITH spend AS (
  SELECT c.customer_unique_id, c.customer_state,
         COUNT(DISTINCT o.order_id) AS orders,
         ROUND(SUM(i.price), 2)     AS total_spent
  FROM orders o
  JOIN customers c   ON c.customer_id = o.customer_id
  JOIN order_items i ON i.order_id = o.order_id
  WHERE o.order_status = 'delivered'
  GROUP BY c.customer_unique_id, c.customer_state
)
SELECT RANK() OVER (ORDER BY total_spent DESC) AS spend_rank,
       customer_unique_id, customer_state, orders, total_spent
FROM spend
ORDER BY spend_rank
LIMIT 10;
