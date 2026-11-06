-- Q7: What share of orders arrive after the estimated delivery date?
SELECT COUNT(*) AS delivered_orders,
       SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_orders,
       ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS late_pct
FROM orders
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL;
