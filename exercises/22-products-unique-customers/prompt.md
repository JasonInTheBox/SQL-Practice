# 22 · Products Bought by More Than 5 Different Customers
**Difficulty:** Medium / Hard

## Tables
```
Product(id PK, name, category, price NUMERIC(10,2))
OrderItem(id PK, order_id -> Orders.id, product_id -> Product.id, quantity INT)
Orders(id PK, customer_id -> Customer.id, amount [nullable], order_date DATE, status)
```

## Task
Find products purchased by **more than 5 unique customers**, considering **non-cancelled orders only**.
A customer who bought the same product several times counts once.

## Output columns
| column | meaning |
|---|---|
| `product_name` | Product.name |
| `category` | |
| `unique_customers` | number of distinct customers who bought it |

**Order by** `unique_customers` descending, then `product_name` ascending.

## Output format
```
product_name,category,unique_customers
...
```

<details><summary>Hint</summary>

`COUNT(DISTINCT o.customer_id)` in `HAVING`. Before you look at your result, predict how
`COUNT(*)` would differ, and how the result changes if you forget the cancelled filter.
</details>
