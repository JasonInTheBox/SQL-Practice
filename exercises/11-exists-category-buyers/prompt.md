# 11 · Customers Who Bought Sports Products
**Difficulty:** Easy / Medium

## Tables
```
Customer(id PK, name, email [nullable], signup_date DATE)
Orders(id PK, customer_id -> Customer.id, amount [nullable], order_date DATE, status)
OrderItem(id PK, order_id -> Orders.id, product_id -> Product.id, quantity INT)
Product(id PK, name, category, price NUMERIC(10,2))
```
Categories: `Electronics`, `Books`, `Home`, `Sports`.

## Task
Find customers who bought **at least one product in the `Sports` category** in a **non-cancelled** order.
Each customer must appear **once**, even if they bought several Sports items.

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

Customer → Orders → OrderItem → Product. Try it with `EXISTS (...)`, then with `IN (...)`,
then with a plain JOIN and notice the duplicate rows a JOIN produces.
</details>
