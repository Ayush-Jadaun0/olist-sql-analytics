-- Q11: How do customers pay, and how large are the payments?
SELECT payment_type,
       COUNT(DISTINCT order_id)      AS orders,
       ROUND(AVG(payment_value), 2)  AS avg_payment,
       ROUND(AVG(payment_installments), 1) AS avg_installments,
       ROUND(100.0 * COUNT(DISTINCT order_id) / (SELECT COUNT(DISTINCT order_id) FROM order_payments), 1) AS share_pct
FROM order_payments
GROUP BY payment_type
ORDER BY orders DESC;
