# 08 · Customers With No Real Orders (NOT EXISTS)
**Difficulty:** Easy / Medium

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount NUMERIC(10,2) [nullable], order_date DATE, status)
```
`status` is one of `completed`, `pending`, `cancelled`.

## Task
Find customers who have **never placed a non-cancelled order**.
That includes customers with no orders at all **and** customers whose only orders were cancelled.

**Practice requirement:** solve it with `NOT EXISTS`.
**Bonus:** afterwards, write the `LEFT JOIN` version too and make sure it returns the same rows.

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

```sql
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.customer_id = c.id AND ...)
```
For the LEFT JOIN bonus: does the status condition belong in `ON` or in `WHERE`? Try both and compare.
</details>
