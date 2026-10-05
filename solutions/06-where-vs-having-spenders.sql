-- 06 - WHERE vs HAVING in the same query: customers who spent more than $1,000
--
-- Logical order of evaluation:
--   FROM/JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
--
-- WHERE o.status <> 'cancelled'
--   Filters individual ROWS before grouping. Cancelled orders never reach SUM.
--   (Ben Carter would be over $1,000 if his cancelled $450 order were counted.)
-- GROUP BY c.id, c.name: one total per customer.
-- HAVING SUM(o.amount) > 1000
--   Filters GROUPS after the sum is known. A row-level WHERE can't see the sum.
SELECT
    c.id          AS customer_id,
    c.name        AS customer_name,
    SUM(o.amount) AS total_spent
FROM Customer c
JOIN Orders o
  ON o.customer_id = c.id
WHERE o.status <> 'cancelled'
GROUP BY c.id, c.name
HAVING SUM(o.amount) > 1000
ORDER BY total_spent DESC;
