-- Q10: Which sellers (with at least 30 reviewed orders) have the lowest average review score?
SELECT i.seller_id, s.seller_state,
       COUNT(DISTINCT i.order_id)    AS reviewed_orders,
       ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM order_items i
JOIN order_reviews r ON r.order_id = i.order_id
JOIN sellers s       ON s.seller_id = i.seller_id
GROUP BY i.seller_id, s.seller_state
HAVING reviewed_orders >= 30
ORDER BY avg_review_score ASC
LIMIT 10;
