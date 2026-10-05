-- 23 - "In every X" = COUNT(DISTINCT X) equals the number of X's
--      Customers with a non-cancelled order in every quarter of 2026
--
-- JOIN Customer -> Orders: we need the customer's name and their orders.
-- WHERE (row filters first):
--   * status <> 'cancelled'          -> Chloe's only Q4 order is cancelled -> she fails.
--   * order_date within 2026         -> Ben's Q4 order is from 2025 -> he fails.
-- GROUP BY c.id, c.name: one group per customer.
-- HAVING COUNT(DISTINCT EXTRACT(QUARTER FROM o.order_date)) = 4
--   Each order maps to quarter 1..4. Several orders in the same quarter count once
--   thanks to DISTINCT. A customer present in all four quarters has exactly 4.
--   Plain COUNT(*) >= 4 would be wrong: Ava had 2 orders in Q1 alone.
--
-- MySQL: QUARTER(o.order_date) instead of EXTRACT(QUARTER FROM o.order_date);
--        YEAR(o.order_date) = 2026 for the year filter.
--
-- See 23-every-quarter-2026.md for a step-by-step walk-through.
SELECT
    c.id   AS customer_id,
    c.name AS customer_name
FROM Customer c
JOIN Orders o ON o.customer_id = c.id
WHERE o.status <> 'cancelled'
  AND o.order_date >= DATE '2026-01-01'
  AND o.order_date <  DATE '2027-01-01'
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT EXTRACT(QUARTER FROM o.order_date)) = 4
ORDER BY c.id;
