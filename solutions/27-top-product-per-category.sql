-- 27 - JOIN + GROUP BY + CTE + window: best-selling product(s) in each category
--
-- units CTE: total units sold per product.
--   JOIN Product -> OrderItem -> Orders (Orders is needed only for status).
--   WHERE o.status <> 'cancelled' removes cancelled lines BEFORE summing.
--     (Otherwise the cancelled Dumbbell Set line would count.)
--   GROUP BY p.id, p.category, p.name: one row per product; SUM(quantity) is units.
--   Units = SUM(quantity), not COUNT(*): one line can hold 3 monitors.
--
-- ranked CTE: RANK() OVER (PARTITION BY category ORDER BY units_sold DESC)
--   PARTITION BY category: a separate leaderboard per category.
--   RANK keeps ties: in Home, Desk Lamp and Throw Blanket both sold 4 units.
--
-- Final: keep rank 1.
--
-- See 27-top-product-per-category.md for a step-by-step walk-through.
WITH units AS (
    SELECT
        p.category,
        p.name          AS product_name,
        SUM(oi.quantity) AS units_sold
    FROM Product p
    JOIN OrderItem oi ON oi.product_id = p.id
    JOIN Orders o     ON o.id = oi.order_id
    WHERE o.status <> 'cancelled'
    GROUP BY p.id, p.category, p.name
),
ranked AS (
    SELECT
        u.*,
        RANK() OVER (PARTITION BY u.category ORDER BY u.units_sold DESC) AS rnk
    FROM units u
)
SELECT
    category,
    product_name,
    units_sold
FROM ranked
WHERE rnk = 1
ORDER BY category, product_name;
