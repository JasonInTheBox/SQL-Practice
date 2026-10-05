-- 15 - Date grouping: order count and revenue per month of 2026
--
-- WHERE (row filters, applied before grouping):
--   * status <> 'cancelled'                    -> cancelled orders are not revenue
--   * order_date in [2026-01-01, 2027-01-01)   -> drops the December 2025 orders
--     (half-open range: works for DATE and TIMESTAMP and lets the DB use an index;
--      EXTRACT(YEAR FROM order_date) = 2026 is also correct, just less index-friendly)
--
-- GROUP BY TO_CHAR(order_date, 'YYYY-MM'): one bucket per calendar month.
--   Group by year+month, never by month number alone, or Jan 2025 and Jan 2026 merge.
--
-- COUNT(*) counts every remaining order, including order 32 whose amount is NULL.
-- SUM(amount) silently ignores NULL amounts. October therefore has 3 orders but
-- revenue from only 2 of them. COALESCE(SUM(...), 0) guards a month where every
-- amount is NULL (SUM would return NULL).
--
-- MySQL equivalents:
--   DATE_FORMAT(order_date, '%Y-%m')   or   YEAR(order_date), MONTH(order_date)
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(*)                       AS order_count,
    COALESCE(SUM(amount), 0)       AS revenue
FROM Orders
WHERE status <> 'cancelled'
  AND order_date >= DATE '2026-01-01'
  AND order_date <  DATE '2027-01-01'
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;
