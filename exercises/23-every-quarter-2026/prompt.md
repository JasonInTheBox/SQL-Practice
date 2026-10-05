# 23 · Customers Who Ordered in Every Quarter of 2026
**Difficulty:** Hard

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount [nullable], order_date DATE, status)
```
`status` is one of `completed`, `pending`, `cancelled`.

## Task
Find customers who placed at least one **non-cancelled** order in **each of the four quarters of 2026**
(Q1 = Jan–Mar, Q2 = Apr–Jun, Q3 = Jul–Sep, Q4 = Oct–Dec).
Pending orders count. Orders from other years do not.

## Output columns
| column | meaning |
|---|---|
| `customer_id` | |
| `customer_name` | |

**Order by** `customer_id` ascending.

## Output format
```
customer_id,customer_name
...
```

<details><summary>Hint</summary>

"Did X in **every** Y" → `GROUP BY` the entity and `HAVING COUNT(DISTINCT y) = <number of Ys>`.
PostgreSQL: `EXTRACT(QUARTER FROM order_date)`. MySQL: `QUARTER(order_date)`.
</details>
