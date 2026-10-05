# 26 · Customers Who Bought From Every Category
**Difficulty:** Hard

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount [nullable], order_date DATE, status)
OrderItem(id PK, order_id -> Orders.id, product_id -> Product.id, quantity INT)
Product(id PK, name, category, price NUMERIC(10,2))
```

## Task
Find customers who, across all their **non-cancelled** orders, bought at least one product from
**every category that exists in the Product table**.
Do not hard-code the number of categories; derive it from `Product`.

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

Join all four tables, group by customer, and compare `COUNT(DISTINCT p.category)` with a scalar subquery
that counts the categories. (Advanced alternative: double `NOT EXISTS`.)
</details>
