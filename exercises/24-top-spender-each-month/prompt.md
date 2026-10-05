# 24 · Top-Spending Customer Each Month
**Difficulty:** Hard

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount NUMERIC(10,2) [nullable], order_date DATE, status)
```
`status` is one of `completed`, `pending`, `cancelled`.

## Task
For each month of **2026**, find the customer(s) who spent the most that month.
- A customer's monthly spend = sum of `amount` of their **non-cancelled** orders in that month.
- Treat a NULL `amount` as **0**.
- If several customers tie for the top spend in a month, return **all** of them.
- Different customers can have the same name; identify customers by `id`.

## Output columns
| column | meaning |
|---|---|
| `month` | text `YYYY-MM` |
| `customer_id` | |
| `customer_name` | |
| `total_spent` | the customer's spend that month |

**Order by** `month` ascending, then `customer_id` ascending.

## Sample output (first row)
```
month,customer_id,customer_name,total_spent
2026-01,2,Ben Carter,300.00
...
```

<details><summary>Hint</summary>

Two levels: first **aggregate** (spend per customer per month), then **rank** within each month
(`PARTITION BY month`). Use CTEs for each level. Where do NULLs sort under `ORDER BY ... DESC` in PostgreSQL?
</details>
