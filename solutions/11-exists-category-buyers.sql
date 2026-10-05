-- 11 - EXISTS across 3 tables: customers who bought a Sports product
--      (in a non-cancelled order)
--
-- The subquery joins Orders -> OrderItem -> Product for ONE customer at a time
-- (correlated through o.customer_id = c.id) and asks "is there at least one
-- non-cancelled Sports line?"
--
-- Why EXISTS instead of a plain JOIN?
--   A JOIN returns one row per matching order line. Ava bought two Sports items,
--   so a join would list her twice and you'd need DISTINCT. EXISTS returns each
--   customer at most once, and stops searching at the first hit.
--
-- IN version (also correct here, since o.customer_id is never NULL):
--   WHERE c.id IN (SELECT o.customer_id FROM Orders o JOIN OrderItem oi ... )
SELECT
    c.id   AS customer_id,
    c.name AS customer_name
FROM Customer c
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    JOIN OrderItem oi ON oi.order_id = o.id      -- order -> its lines
    JOIN Product p    ON p.id = oi.product_id    -- line  -> product (for category)
    WHERE o.customer_id = c.id
      AND o.status <> 'cancelled'
      AND p.category = 'Sports'
)
ORDER BY c.id;
