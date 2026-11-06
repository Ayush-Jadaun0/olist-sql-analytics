-- Q9: Which 10 sellers earn the most revenue?
SELECT i.seller_id, s.seller_state,
       COUNT(DISTINCT i.order_id) AS orders,
       ROUND(SUM(i.price), 2)     AS revenue
FROM order_items i
JOIN orders o  ON o.order_id = i.order_id AND o.order_status = 'delivered'
JOIN sellers s ON s.seller_id = i.seller_id
GROUP BY i.seller_id, s.seller_state
ORDER BY revenue DESC
LIMIT 10;
