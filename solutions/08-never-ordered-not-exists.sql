-- 08 - Rows with no match, NOT EXISTS version
--     "Customers who have never placed a NON-cancelled order"
--
-- NOT EXISTS (correlated subquery):
--   For each customer row c, the subquery looks for at least one order of c that
--   is not cancelled. If none is found, NOT EXISTS is TRUE and c is returned.
--   "SELECT 1" -- the selected value is irrelevant; EXISTS only asks "any row?".
--
-- Why NOT EXISTS is preferable here:
--   * The extra condition (status <> 'cancelled') sits naturally inside the subquery.
--   * It can never create duplicate rows (a JOIN can).
--   * It stops at the first matching order (an "anti join") -> efficient.
--   * NOT IN is dangerous: if the subquery returns any NULL, NOT IN returns no rows.
--
-- Equivalent LEFT JOIN -- the status filter MUST go in the ON clause, not in WHERE:
--   SELECT c.id, c.name
--   FROM Customer c
--   LEFT JOIN Orders o ON o.customer_id = c.id AND o.status <> 'cancelled'
--   WHERE o.id IS NULL;
-- Putting "o.status <> 'cancelled'" in WHERE instead would throw away the
-- NULL-padded rows (NULL <> 'cancelled' is not TRUE) and Mason would be lost.
SELECT
    c.id   AS customer_id,
    c.name AS customer_name
FROM Customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.id          -- correlation: ties the subquery to the outer row
      AND o.status <> 'cancelled'
)
ORDER BY c.id;
