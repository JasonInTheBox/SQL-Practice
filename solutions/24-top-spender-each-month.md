# 24 · Top spender each month, step by step

## Pattern
"Top X **per** Y where X is itself a total" → **aggregate first, then rank**.
You can't rank customers by monthly spend until the monthly spend exists.

## Step 1 · `monthly`: aggregate
```sql
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month, customer_id,
       SUM(COALESCE(amount, 0)) AS total_spent
FROM Orders
WHERE status <> 'cancelled' AND order_date >= '2026-01-01' AND order_date < '2027-01-01'
GROUP BY 1, 2
```
September after this step:

| month | customer | total_spent |
|---|---|---:|
| 2026-09 | Lena (13) | 120.00 |
| 2026-09 | Kai (12)  | 120.00 |

(Mason's 315.00 order is cancelled, so it's filtered out by WHERE.)

October:

| month | customer | total_spent |
|---|---|---:|
| 2026-10 | Ava (1)    | 25.00 |
| 2026-10 | Daniel (4) | 47.00 |
| 2026-10 | Felix (6)  | **0.00**, but NULL without COALESCE |

## Step 2 · `ranked`: rank inside each month
`RANK() OVER (PARTITION BY month ORDER BY total_spent DESC)`
- `PARTITION BY month` gives a separate leaderboard per month.
- `RANK` gives Lena and Kai both rank 1 in September.
- PostgreSQL sorts **NULLs first** for `DESC`. If Felix's total were NULL he'd be rank 1 in October.
  Fixes: `COALESCE(amount, 0)`, or `ORDER BY total_spent DESC NULLS LAST`.

## Step 3 · keep rank 1 and attach names
`JOIN Customer` **by id** (two different customers are both called "Ava Thompson").

## MySQL version of the month bucket
`DATE_FORMAT(order_date, '%Y-%m')`. MySQL 8+ supports the same `RANK() OVER (...)`.
