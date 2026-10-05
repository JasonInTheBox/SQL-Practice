-- 22 - COUNT(DISTINCT) + HAVING across 3 tables:
--      products bought by more than 5 different customers (non-cancelled orders)
--
-- JOINs:
--   Product  -> OrderItem  (which order lines contain this product)
--   OrderItem -> Orders    (who placed that order, and its status)
-- WHERE o.status <> 'cancelled': row filter before grouping.
--   Including cancelled orders would push 'SQL Pocket Guide' from 5 to 6 customers.
-- GROUP BY p.id, p.name, p.category: one group per product.
-- COUNT(DISTINCT o.customer_id) vs COUNT(*):
--   COUNT(*) counts order LINES. Ava bought the mouse in two different orders,
--   so the mouse has 7 lines but only 6 distinct customers.
-- HAVING ... > 5: filter on the aggregate -> HAVING. ("more than 5" excludes 5.)
SELECT
    p.name     AS product_name,
    p.category,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM Product p
JOIN OrderItem oi ON oi.product_id = p.id
JOIN Orders o     ON o.id = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY p.id, p.name, p.category
HAVING COUNT(DISTINCT o.customer_id) > 5
ORDER BY unique_customers DESC, product_name;
