# 23 · Ordered in every quarter of 2026, step by step

## Pattern
"Entity did X in **every** Y" →
```sql
GROUP BY entity
HAVING COUNT(DISTINCT y) = (number of possible y)
```

## Step 1 · rows that count
`WHERE status <> 'cancelled' AND order_date >= '2026-01-01' AND order_date < '2027-01-01'`

## Step 2 · map each order to its quarter
`EXTRACT(QUARTER FROM order_date)` → 1, 2, 3, 4  (MySQL: `QUARTER(order_date)`)

| customer | quarters seen (after the WHERE) | distinct |
|---|---|---:|
| Ava (1)    | 1, 1, 2, 3, 4 (Q4 order is *pending*, which counts) | **4** ✔ |
| Ben (2)    | 1, 2, 3 (his Q4 order is from **2025**; his Q1 cancelled order is dropped) | 3 |
| Chloe (3)  | 1, 2, 3 (her only Q4 order is **cancelled**) | 3 |
| Daniel (4) | 1, 2, 3, 4 | **4** ✔ |

## Step 3 · group and test
`GROUP BY c.id, c.name HAVING COUNT(DISTINCT EXTRACT(QUARTER FROM o.order_date)) = 4`

## Common wrong answers
- `COUNT(*) >= 4` counts orders, not quarters (Ella has 3 orders all in March).
- No year filter → Ben sneaks in via his December 2025 order.
- No status filter → Chloe sneaks in via her cancelled October order.
