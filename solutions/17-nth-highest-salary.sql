-- 17 - Nth highest salary (global)
--
-- Salaries sorted:  250000, 180000, 180000, 165000, ...
--   2nd highest DISTINCT salary = 180000   (DENSE_RANK = 2)
--   3rd highest DISTINCT salary = 165000   (DENSE_RANK = 3)
--   salary on the 3rd ROW       = 180000   (ROW_NUMBER = 3, duplicates counted)
--   RANK = 3 does not exist at all (ranks go 1, 2, 2, 4) -> never use RANK for "Nth".
--
-- Step 1 (CTE ranked): attach both rankings to every employee row.
-- Step 2: collapse to ONE row. MAX(CASE WHEN ... THEN salary END) picks the salary
--   with the wanted rank (several rows can share it; MAX of equal values is that
--   value). If no row has that rank, MAX over nothing = NULL, which is exactly the
--   classic "return NULL if there is no Nth highest" requirement.
--
-- Classic alternatives (good to recognise):
--   PostgreSQL / MySQL:
--     SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT 1 OFFSET 2;
--     -- returns NO ROW (not NULL) when missing; wrap as (SELECT ...) to get NULL.
--   Second highest without window functions:
--     SELECT MAX(salary) FROM Employee WHERE salary < (SELECT MAX(salary) FROM Employee);
WITH ranked AS (
    SELECT
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS dr,
        ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn
    FROM Employee
)
SELECT
    MAX(CASE WHEN dr = 2 THEN salary END) AS second_highest_distinct,
    MAX(CASE WHEN dr = 3 THEN salary END) AS third_highest_distinct,
    MAX(CASE WHEN rn = 3 THEN salary END) AS third_row_salary
FROM ranked;
