# 15 · Monthly Revenue for 2026
**Difficulty:** Medium

## Tables
```
Orders(id PK, customer_id -> Customer.id, amount NUMERIC(10,2) [nullable], order_date DATE, status)
```
`status` is one of `completed`, `pending`, `cancelled`.

## Task
For each month of **2026** that has orders, report the number of orders and total revenue.
- **Exclude cancelled orders** (from both the count and the revenue).
- Orders from other years must not be included.
- An order with a NULL `amount` still counts as an order but adds nothing to revenue.

## Output columns
| column | meaning |
|---|---|
| `month` | text in the form `YYYY-MM`, e.g. `2026-01` |
| `order_count` | number of non-cancelled orders that month |
| `revenue` | sum of their amounts (2 decimals, as stored) |

**Order by** `month` ascending.

## Sample output (first row)
```
month,order_count,revenue
2026-01,3,424.00
...
```

<details><summary>Hint</summary>

PostgreSQL: `TO_CHAR(order_date, 'YYYY-MM')` or `DATE_TRUNC('month', order_date)`.
MySQL: `DATE_FORMAT(order_date, '%Y-%m')`.
</details>
