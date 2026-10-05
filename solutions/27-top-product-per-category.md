# 27 · Best-selling product per category, step by step

This one combines everything: JOIN + WHERE + GROUP BY + CTE + window + filter on rank.

## Step 1 · `units`: units sold per product
```
Product -> OrderItem   (lines for the product, with quantity)
OrderItem -> Orders    (only to read status)
WHERE status <> 'cancelled'
GROUP BY product -> SUM(quantity)
```
| category | product | units_sold |
|---|---|---:|
| Home | Coffee Maker  | 3 |
| Home | Desk Lamp     | 4 |
| Home | Throw Blanket | 4 |
| Sports | Yoga Mat     | 4 |
| Sports | Dumbbell Set | 2 (it would be 3 if you forgot the cancelled filter) |
| Electronics | Monitor 27in | 5 (3 of them on ONE order line, which is why it's `SUM(quantity)`, not `COUNT(*)`) |

Products never sold (Tennis Racket) have no lines, so they're absent. That's harmless here, since they can't be top.
(If the question were "units for every product, including 0", you'd `LEFT JOIN` and `COALESCE(SUM(...), 0)`,
and put the status filter in the `ON` clause.)

## Step 2 · `ranked`: leaderboard per category
`RANK() OVER (PARTITION BY category ORDER BY units_sold DESC)`
Home: Desk Lamp 1, Throw Blanket 1, Coffee Maker 3.

## Step 3 · keep `rnk = 1`, order by category and product name

## Variation to try
"Top product per category, but break ties by revenue": add a second key,
`ORDER BY units_sold DESC, revenue DESC`, and compute `SUM(oi.quantity * p.price) AS revenue` in step 1.
