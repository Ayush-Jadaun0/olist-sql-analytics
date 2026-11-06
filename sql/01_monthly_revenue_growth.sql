-- Q1: How does monthly revenue and order volume change, and what is the month-over-month growth?
-- Restricted to Jan 2017 - Aug 2018: the months outside this range have too little data.
WITH monthly AS (
  SELECT strftime('%Y-%m', o.order_purchase_timestamp) AS month,
         COUNT(DISTINCT o.order_id)                     AS orders,
         ROUND(SUM(i.price), 2)                         AS revenue
  FROM orders o
  JOIN order_items i ON i.order_id = o.order_id
  WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp <  '2018-09-01'
  GROUP BY month
)
SELECT month, orders, revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS growth_pct
FROM monthly
ORDER BY month;