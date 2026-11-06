-- Q6: How many days does delivery take on average in each state?
SELECT c.customer_state AS state,
       COUNT(*) AS orders,
       ROUND(AVG(julianday(o.order_delivered_customer_date)
               - julianday(o.order_purchase_timestamp)), 1) AS avg_delivery_days
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY state
HAVING orders >= 100
ORDER BY avg_delivery_days DESC;
