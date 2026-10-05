-- 05 - HAVING: customers with at least 3 orders (any status)
--
-- JOIN: INNER JOIN Customer -> Orders; customers without orders can't have >= 3 anyway.
-- GROUP BY c.id, c.name: one group per CUSTOMER.
--   Group by the id, not just the name: there are two different customers called
--   'Ava Thompson' (ids 1 and 10). Grouping by name alone would merge them.
-- HAVING (not WHERE): "order count >= 3" is a fact about the GROUP, which only
--   exists after GROUP BY. WHERE runs earlier, row by row, before groups exist,
--   so WHERE COUNT(*) >= 3 is an error.
SELECT
    c.id     AS customer_id,
    c.name   AS customer_name,
    COUNT(*) AS order_count
FROM Customer c
JOIN Orders o
  ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(*) >= 3
ORDER BY order_count DESC, c.id;
