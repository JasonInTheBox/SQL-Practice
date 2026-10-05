-- 19 - Nth highest per group: third-highest DISTINCT salary in each department
--
-- DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)
--   PARTITION BY department_id -> separate ranking per department.
--   DENSE_RANK -> rank N = Nth distinct salary, ties don't create gaps.
--     Engineering: 180000 (1), 150000 x2 (2), 130000 (3)  -> Irene
--     With RANK, Irene would be rank 4 and Engineering would return nothing.
--     With ROW_NUMBER, Henry (150000) would be "3rd" -- wrong, that's a repeat salary.
--   Finance: 165000 (1), 120000 (2), 85000 x2 (3) -> BOTH Tina and Uma.
--   Executive and HR have fewer than 3 distinct salaries -> no rows (by design).
--
-- See 19-third-highest-per-department.md for a step-by-step walk-through.
WITH ranked AS (
    SELECT
        e.*,
        DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS dr
    FROM Employee e
)
SELECT
    d.department_name,
    r.name AS employee_name,
    r.salary
FROM ranked r
JOIN Department d ON d.id = r.department_id
WHERE r.dr = 3
ORDER BY d.department_name, r.name;
