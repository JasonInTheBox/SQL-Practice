-- 07 - Rows with no match (anti-join), LEFT JOIN version
--
-- LEFT JOIN keeps every customer. For a customer with no orders, the single
-- output row has every o.* column = NULL.
-- WHERE o.id IS NULL keeps exactly those "no partner found" rows.
--   Test the joined table's PRIMARY KEY (o.id): it is never NULL in real rows,
--   so NULL can only mean "no match". Testing a nullable column like o.amount
--   would also catch real orders whose amount happens to be NULL (order 32!).
-- No GROUP BY needed: unmatched customers produce exactly one row each.
SELECT
    c.id   AS customer_id,
    c.name AS customer_name
FROM Customer c
LEFT JOIN Orders o
  ON o.customer_id = c.id
WHERE o.id IS NULL
ORDER BY c.id;
