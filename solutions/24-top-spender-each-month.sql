-- 24 - Aggregate THEN rank: top-spending customer(s) in each month of 2026
--
-- Two-level problem -> two CTEs:
--
-- monthly : GROUP BY (month, customer) -> how much each customer spent each month.
--   WHERE filters rows first: non-cancelled, 2026 only.
--   COALESCE(o.amount, 0): order 32 has a NULL amount. Without COALESCE, Felix's
--   October total would be NULL, and in PostgreSQL NULLs sort FIRST under DESC,
--   so Felix would wrongly be "top spender" of October.
--   (MySQL sorts NULLs LAST under DESC -- another reason to remove NULLs explicitly.)
--
-- ranked  : RANK() OVER (PARTITION BY month ORDER BY total_spent DESC)
--   PARTITION BY month: a separate leaderboard for every month.
--   RANK keeps ties: in September Kai and Lena both spent 120.00 -> both rank 1.
--
-- Final: keep rank 1, JOIN Customer for the name (join by id, because two
-- different customers share the name 'Ava Thompson').
--
-- See 24-top-spender-each-month.md for a step-by-step walk-through.
WITH monthly AS (
    SELECT
        TO_CHAR(o.order_date, 'YYYY-MM') AS month,
        o.customer_id,
        SUM(COALESCE(o.amount, 0))       AS total_spent
    FROM Orders o
    WHERE o.status <> 'cancelled'
      AND o.order_date >= DATE '2026-01-01'
      AND o.order_date <  DATE '2027-01-01'
    GROUP BY TO_CHAR(o.order_date, 'YYYY-MM'), o.customer_id
),
ranked AS (
    SELECT
        m.*,
        RANK() OVER (PARTITION BY m.month ORDER BY m.total_spent DESC) AS rnk
    FROM monthly m
)
SELECT
    r.month,
    c.id   AS customer_id,
    c.name AS customer_name,
    r.total_spent
FROM ranked r
JOIN Customer c ON c.id = r.customer_id
WHERE r.rnk = 1
ORDER BY r.month, c.id;
