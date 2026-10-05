# 06 · Big Spenders (WHERE vs HAVING)
**Difficulty:** Easy / Medium

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount NUMERIC(10,2) [nullable], order_date DATE, status)
```
`status` is one of `completed`, `pending`, `cancelled`.

## Task
Find customers whose total spending is **greater than $1,000**.
Total spending = sum of `amount` over the customer's orders, **excluding cancelled orders**.
Use all dates (no year filter).

## Output columns
| column | meaning |
|---|---|
| `customer_id` | |
| `customer_name` | |
| `total_spent` | sum of non-cancelled order amounts |

**Order by** `total_spent` descending.

## Output format
```
customer_id,customer_name,total_spent
...
```

<details><summary>Hint</summary>

This query needs **both** filters:
- one that removes individual rows *before* grouping, and
- one that removes whole groups *after* the sum is computed.

Which is `WHERE` and which is `HAVING`?
</details>
