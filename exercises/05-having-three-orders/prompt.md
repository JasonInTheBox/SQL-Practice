# 05 · Customers With at Least 3 Orders
**Difficulty:** Easy

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount NUMERIC(10,2) [nullable], order_date DATE, status)
```
`status` is one of `completed`, `pending`, `cancelled`.

## Task
Find customers who have placed **at least 3 orders**. Count orders of **any** status.

Note: two different customers may share the same name. Treat them as different customers.

## Output columns
| column | meaning |
|---|---|
| `customer_id` | Customer.id |
| `customer_name` | Customer.name |
| `order_count` | number of orders placed |

**Order by** `order_count` descending, then `customer_id` ascending.

## Sample output (first row)
```
customer_id,customer_name,order_count
1,Ava Thompson,6
...
```

<details><summary>Hint</summary>

The condition "at least 3" is about a **count**, which only exists after grouping.
Row filters go in `WHERE`; group filters go in `HAVING`.
</details>
