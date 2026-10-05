# 25 · Consecutive months, step by step

## Step 1 · one row per (customer, month)
```sql
SELECT DISTINCT customer_id, DATE_TRUNC('month', order_date)::date AS month
FROM Orders WHERE status <> 'cancelled'
```
Ben (2): `2025-12-01, 2026-01-01, 2026-05-01, 2026-08-01` (his March order is cancelled)
Gina (7): `2026-05-01, 2026-06-01, 2026-08-01`

## Step 2a · self-join version (used in the .sql)
Pair every month `a` with a month `b` of the same customer where `b = a + 1 month`.
Any pair proves the customer qualifies. `SELECT DISTINCT` collapses customers with several pairs.

## Step 2b · LAG version
```sql
WITH months AS ( ...step 1... ),
with_prev AS (
    SELECT customer_id, month,
           LAG(month) OVER (PARTITION BY customer_id ORDER BY month) AS prev_month
    FROM months
)
SELECT DISTINCT c.id AS customer_id, c.name AS customer_name
FROM with_prev w
JOIN Customer c ON c.id = w.customer_id
WHERE w.month = (w.prev_month + INTERVAL '1 month')::date
ORDER BY c.id;
```
`LAG(month)` = "the value of `month` on the previous row of the same partition".
`PARTITION BY customer_id` stops it from reading another customer's row.

## The year-boundary trap
Comparing month **numbers**: Dec = 12, Jan = 1, and `1 - 12 = -11`, so Ben is missed.
Comparing real dates: `2025-12-01 + 1 month = 2026-01-01` ✔.
If you must use numbers: `year * 12 + month` gives a running month index, and consecutive means a difference of 1.

## MySQL
- month start: `DATE_FORMAT(order_date, '%Y-%m-01')` or `DATE_SUB(order_date, INTERVAL DAY(order_date)-1 DAY)`
- next month: `DATE_ADD(month, INTERVAL 1 MONTH)`
- or `PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM b), EXTRACT(YEAR_MONTH FROM a)) = 1`
