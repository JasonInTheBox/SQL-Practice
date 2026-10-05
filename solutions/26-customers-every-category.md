# 26 · Bought from every category, step by step

## Step 1 · build customer × category rows
Customer → Orders → OrderItem → Product, keeping non-cancelled orders.
Each row is one order line; `p.category` tells us which category it hit.

## Step 2 · count distinct categories per customer
| customer | categories (non-cancelled) | count |
|---|---|---:|
| Ava (1)    | Books, Electronics, Home, Sports | **4** ✔ |
| Ben (2)    | Electronics, Home, Books (his Sports item was in a *cancelled* order) | 3 |
| Daniel (4) | Electronics, Books, Sports, Home | **4** ✔ |
| Ella (5)   | Sports, Electronics, Books, Home (only 3 orders, all in March) | **4** ✔ |
| Gina (7)   | Electronics, Home, Sports, Books | **4** ✔ |

## Step 3 · compare to the number of categories
`HAVING COUNT(DISTINCT p.category) = (SELECT COUNT(DISTINCT category) FROM Product)`.
The scalar subquery returns 4. Deriving it instead of typing `4` keeps the query correct when
categories change. Interviewers notice this.

## Alternative: double NOT EXISTS ("relational division")
Read it as: *there is no category that this customer has not bought from*.
```sql
SELECT c.id AS customer_id, c.name AS customer_name
FROM Customer c
WHERE NOT EXISTS (                                   -- no category ...
    SELECT 1 FROM (SELECT DISTINCT category FROM Product) cat
    WHERE NOT EXISTS (                               -- ... that this customer never bought
        SELECT 1
        FROM Orders o
        JOIN OrderItem oi ON oi.order_id = o.id
        JOIN Product p    ON p.id = oi.product_id
        WHERE o.customer_id = c.id
          AND o.status <> 'cancelled'
          AND p.category = cat.category
    )
)
ORDER BY c.id;
```
