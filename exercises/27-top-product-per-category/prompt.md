# 27 · Best-Selling Product in Each Category
**Difficulty:** Hard

## Tables
```
Product(id PK, name, category, price NUMERIC(10,2))
OrderItem(id PK, order_id -> Orders.id, product_id -> Product.id, quantity INT)
Orders(id PK, customer_id -> Customer.id, amount [nullable], order_date DATE, status)
```

## Task
For each product category, find the product(s) with the **most units sold**.
- Units sold = total `quantity` across **non-cancelled** orders.
- If several products tie for the most units in a category, return all of them.

## Output columns
| column | meaning |
|---|---|
| `category` | |
| `product_name` | |
| `units_sold` | |

**Order by** `category` ascending, then `product_name` ascending.

## Output format
```
category,product_name,units_sold
...
```

<details><summary>Hint</summary>

CTE 1: `SUM(quantity)` per product (JOIN + WHERE + GROUP BY).
CTE 2: `RANK() OVER (PARTITION BY category ORDER BY units_sold DESC)`.
Final: keep rank 1.
</details>
