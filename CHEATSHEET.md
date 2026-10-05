# SQL OA Cheat Sheet: Pattern → Template

## 0. Read the question → pick the pattern

| The question says… | Reach for |
|---|---|
| "…and their department / manager name" | `JOIN` (self join for manager) |
| "**all** X, **even if** no Y" / "including those with 0" | `LEFT JOIN`, X on the left, `COUNT(y.id)` |
| "X that have **no** Y" / "never" | `LEFT JOIN … WHERE y.id IS NULL` **or** `NOT EXISTS` |
| "per / for each / by" | `GROUP BY` |
| filter on a **count / sum / avg** | `HAVING`, not `WHERE` |
| "unique / different / distinct" | `COUNT(DISTINCT …)` |
| "in **every** quarter / category" | `HAVING COUNT(DISTINCT x) = (total number of x)` |
| "above the average / the max" | scalar subquery `(SELECT AVG(…) FROM …)` |
| "bought at least one …" (no duplicates) | `EXISTS` |
| "Nth highest **distinct**" | `DENSE_RANK() = N` |
| "top N **people** per group" | `ROW_NUMBER() OVER (PARTITION BY g ORDER BY …) <= N` |
| "highest in each group, **include ties**" | `RANK() OVER (PARTITION BY g …) = 1` |
| "top X per month" where X is a total | CTE aggregate **then** CTE rank |
| "consecutive months / days" | `LAG()` or self-join on `date + INTERVAL '1 month'` |
| "duplicates" | `GROUP BY col HAVING COUNT(*) > 1` |
| several steps in one problem | one CTE per step |

**Execution order:** `FROM/JOIN → WHERE → GROUP BY → HAVING → window fns → SELECT → DISTINCT → ORDER BY → LIMIT`
→ You can't use an aggregate in `WHERE`, or a window function in `WHERE`/`HAVING`. Wrap it in a CTE.

---

## 1. INNER JOIN: only matching rows
```sql
SELECT e.name, d.department_name
FROM Employee e
JOIN Department d ON e.department_id = d.id;
```

## 2. LEFT JOIN: keep every left row
```sql
SELECT d.department_name, COUNT(e.id) AS cnt      -- COUNT(e.id), NOT COUNT(*)
FROM Department d
LEFT JOIN Employee e ON e.department_id = d.id
GROUP BY d.id, d.department_name;
```
⚠ A filter on the **right** table goes in `ON`. Put it in `WHERE` and you've turned it back into an INNER JOIN.

## 3. Self join
```sql
SELECT e.name AS employee, m.name AS manager
FROM Employee e
LEFT JOIN Employee m ON e.manager_id = m.id;     -- LEFT keeps the boss (manager NULL)
```

## 4. GROUP BY + 5. HAVING
```sql
SELECT customer_id, COUNT(*) AS n, SUM(amount) AS total
FROM Orders
WHERE status <> 'cancelled'        -- row filter (before grouping)
GROUP BY customer_id
HAVING SUM(amount) > 1000;         -- group filter (after grouping)
```
Every non-aggregated SELECT column must be in `GROUP BY`. Group by **id**, not name (names can repeat).

## 6. COUNT(DISTINCT)
```sql
SELECT product_id, COUNT(DISTINCT customer_id) AS buyers ... GROUP BY product_id HAVING COUNT(DISTINCT customer_id) > 5;
```
`COUNT(*)` counts rows · `COUNT(col)` counts non-NULL · `COUNT(DISTINCT col)` counts unique non-NULL.

## 7. CTE
```sql
WITH step1 AS (SELECT ...),
     step2 AS (SELECT ... FROM step1)
SELECT * FROM step2;
```

## 8. Subqueries
```sql
-- scalar
WHERE salary > (SELECT AVG(salary) FROM Employee)
-- IN
WHERE id IN (SELECT customer_id FROM Orders)
-- correlated scalar
WHERE salary = (SELECT MAX(salary) FROM Employee x WHERE x.department_id = e.department_id)
```

## 9. EXISTS / NOT EXISTS
```sql
SELECT c.* FROM Customer c
WHERE EXISTS     (SELECT 1 FROM Orders o WHERE o.customer_id = c.id);   -- has at least one
SELECT c.* FROM Customer c
WHERE NOT EXISTS (SELECT 1 FROM Orders o WHERE o.customer_id = c.id);   -- has none
```
Prefer `NOT EXISTS` over `NOT IN`: **`NOT IN` returns nothing if the subquery contains a NULL.**
EXISTS never duplicates rows and stops at the first match.

## 10. Rows with no match (anti-join)
```sql
SELECT c.* FROM Customer c
LEFT JOIN Orders o ON o.customer_id = c.id     -- extra conditions on o go HERE
WHERE o.id IS NULL;                            -- test the PK of the right table
```

## 11. ROW_NUMBER / RANK / DENSE_RANK
```
salary   ROW_NUMBER  RANK  DENSE_RANK
250          1         1       1
180          2         2       2
180          3         2       2
165          4         4       3
```
```sql
ROW_NUMBER() OVER (ORDER BY salary DESC, id)                     -- unique; add a tie-breaker
RANK()       OVER (ORDER BY salary DESC)                         -- ties share, then gap
DENSE_RANK() OVER (ORDER BY salary DESC)                         -- ties share, no gap
DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)  -- restart per dept
```
`PARTITION BY` = "GROUP BY for window functions, but rows are not collapsed".

## 12. Nth highest value
```sql
-- Nth highest DISTINCT salary (NULL if none)
WITH r AS (SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS dr FROM Employee)
SELECT MAX(salary) AS nth FROM r WHERE dr = 3;

-- LIMIT/OFFSET style (Postgres & MySQL); wrap in () to get NULL instead of no row
SELECT (SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT 1 OFFSET 2) AS third;

-- 2nd highest, no window function
SELECT MAX(salary) FROM Employee WHERE salary < (SELECT MAX(salary) FROM Employee);
```

## 13. Top N per group
```sql
WITH r AS (
  SELECT e.*, ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC, id) AS rn
  FROM Employee e
)
SELECT * FROM r WHERE rn <= 3;        -- RANK() = 1 instead if "include ties"
```

## 14. Date grouping
| | PostgreSQL | MySQL |
|---|---|---|
| month bucket (text) | `TO_CHAR(d, 'YYYY-MM')` | `DATE_FORMAT(d, '%Y-%m')` |
| month start (date) | `DATE_TRUNC('month', d)::date` | `DATE_FORMAT(d, '%Y-%m-01')` |
| year / month / quarter | `EXTRACT(YEAR FROM d)` / `MONTH` / `QUARTER` | `YEAR(d)` / `MONTH(d)` / `QUARTER(d)` |
| add a month | `d + INTERVAL '1 month'` | `DATE_ADD(d, INTERVAL 1 MONTH)` |
| days between | `d2 - d1` (integer) | `DATEDIFF(d2, d1)` |
| date range (safe) | `d >= '2026-01-01' AND d < '2027-01-01'` | same |

⚠ Group by **year + month**, never month alone. ⚠ `BETWEEN` is inclusive on both ends.

## 15. CASE WHEN
```sql
SELECT name,
       CASE WHEN salary >= 150000 THEN 'high'
            WHEN salary >= 100000 THEN 'mid'
            ELSE 'low' END AS band
FROM Employee;

-- conditional aggregation ("pivot")
SELECT customer_id,
       SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
       SUM(CASE WHEN status <> 'cancelled' THEN amount ELSE 0 END) AS real_spend
FROM Orders GROUP BY customer_id;
```

## 16. COALESCE: replace NULL
```sql
COALESCE(amount, 0)            -- NULL → 0 before summing/sorting
COALESCE(m.name, 'No manager') -- NULL from a LEFT JOIN → label
```

## 17. NULL gotchas (cost points in OAs)
- `x = NULL` is never true → use `IS NULL`.
- `GROUP BY` puts all NULLs in **one** group.
- `SUM/AVG/COUNT(col)` ignore NULLs; `COUNT(*)` doesn't.
- `ORDER BY x DESC`: Postgres puts NULLs **first**, MySQL **last** → `NULLS LAST` (PG) or COALESCE.
- `NOT IN (subquery with NULL)` → empty result.

## 18. Final-answer checklist
1. Right **columns** in the right **order**, with the requested aliases?
2. **ORDER BY** exactly as asked (+ tie-breaker)?
3. Status / year filters applied?
4. Ties: should they be included (RANK/DENSE_RANK) or not (ROW_NUMBER)?
5. Should entities with zero matches appear (LEFT JOIN)?
6. Rounding (`ROUND(x, 2)`)?
