# 07 · Customers Who Never Ordered (LEFT JOIN)
**Difficulty:** Easy / Medium

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount NUMERIC(10,2) [nullable], order_date DATE, status)
```

## Task
Find customers who have **never placed any order** (of any status).

**Practice requirement:** solve this one with a `LEFT JOIN` (exercise 08 practices `NOT EXISTS`).

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

`LEFT JOIN` the related table, then keep the rows where the related table's **primary key** `IS NULL`.
(Why the primary key and not, say, `amount`? Some real orders have a NULL amount.)
</details>
