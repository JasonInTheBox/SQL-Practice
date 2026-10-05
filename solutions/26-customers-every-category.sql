-- 26 - Relational division: customers who bought from EVERY product category
--
-- JOIN chain (4 tables): Customer -> Orders -> OrderItem -> Product
--   gives one row per (customer, order line, product) so we can see categories.
-- WHERE o.status <> 'cancelled': Ben's only Sports purchase is in a cancelled
--   order, so he must NOT qualify.
-- GROUP BY c.id, c.name: one group per customer.
-- HAVING COUNT(DISTINCT p.category) = (SELECT COUNT(DISTINCT category) FROM Product)
--   Left side : how many different categories this customer bought from.
--   Right side: scalar subquery, how many categories exist (4).
--   Equal -> the customer covered every category.
--   The right side is computed from Product, not hard-coded as 4, so the query
--   stays correct if a new category is added.
--
-- See 26-customers-every-category.md for the double NOT EXISTS formulation.
SELECT
    c.id   AS customer_id,
    c.name AS customer_name
FROM Customer c
JOIN Orders o     ON o.customer_id = c.id
JOIN OrderItem oi ON oi.order_id = o.id
JOIN Product p    ON p.id = oi.product_id
WHERE o.status <> 'cancelled'
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT p.category) = (SELECT COUNT(DISTINCT category) FROM Product)
ORDER BY c.id;
