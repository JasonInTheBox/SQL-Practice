# 25 · Customers Who Ordered in Consecutive Months
**Difficulty:** Hard

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount [nullable], order_date DATE, status)
```

## Task
Find customers who placed **non-cancelled** orders in **two consecutive calendar months**
(for example May and June 2026, or **December 2025 and January 2026**). Consider all years.

## Output columns
| column | meaning |
|---|---|
| `customer_id` | |
| `customer_name` | |

Each qualifying customer appears once. **Order by** `customer_id` ascending.

## Output format
```
customer_id,customer_name
...
```

<details><summary>Hint</summary>

Reduce each order to the **first day of its month** (`DATE_TRUNC('month', order_date)`), de-duplicate,
then either self-join on `b.month = a.month + INTERVAL '1 month'` or use `LAG()`.
Why does comparing `EXTRACT(MONTH ...)` numbers fail?
</details>
