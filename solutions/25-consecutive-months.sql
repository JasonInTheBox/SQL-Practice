-- 25 - Consecutive periods: customers with non-cancelled orders in two
--      consecutive calendar months (any year)
--
-- months CTE: DISTINCT (customer, first day of month).
--   DATE_TRUNC('month', d) turns 2026-03-20 into 2026-03-01. Keeping a real DATE
--   (not a month NUMBER) is what makes December -> January work:
--   2025-12-01 + 1 month = 2026-01-01.  With EXTRACT(MONTH ...) you'd compare
--   12 and 1 and miss Ben Carter.
--   DISTINCT so three orders in March become one "March" row.
--
-- Self join months a -> months b:
--   same customer, and b's month is exactly one month after a's month.
--   Any matching pair proves the customer qualifies.
-- SELECT DISTINCT: a customer with several consecutive pairs (Ava) appears once.
--
-- Window-function alternative (see 25-consecutive-months.md):
--   LAG(month) OVER (PARTITION BY customer_id ORDER BY month) and test
--   month = prev_month + INTERVAL '1 month'.
--
-- MySQL: DATE_FORMAT(order_date, '%Y-%m-01') for the month start,
--        DATE_ADD(a.month, INTERVAL 1 MONTH) for "next month",
--        or PERIOD_DIFF(YEAR(b)*100+MONTH(b), YEAR(a)*100+MONTH(a)) = 1.
WITH months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', order_date)::date AS month
    FROM Orders
    WHERE status <> 'cancelled'
)
SELECT DISTINCT
    c.id   AS customer_id,
    c.name AS customer_name
FROM months a
JOIN months b
  ON b.customer_id = a.customer_id
 AND b.month = (a.month + INTERVAL '1 month')::date
JOIN Customer c ON c.id = a.customer_id
ORDER BY c.id;
