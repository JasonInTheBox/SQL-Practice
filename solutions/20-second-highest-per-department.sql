-- 20 - Second-highest salary for EVERY department (NULL when there isn't one)
--
-- Three steps, each a CTE:
--   ranked : DENSE_RANK per department (PARTITION BY department_id).
--            WHERE department_id IS NOT NULL drops the contractor, who would
--            otherwise form her own "NULL department" partition.
--   second : the salary with dense rank 2 in each department.
--            DISTINCT because ties produce several rows with the same salary
--            (Engineering: Grace AND Henry are both rank 2 at 150000). Without
--            DISTINCT, Engineering would appear twice after the join.
--   final  : Department LEFT JOIN second -> every department appears once;
--            departments without a 2nd distinct salary get NULL:
--              Executive (1 person), HR (two people TIED at the top),
--              Legal & Research (nobody).
--
-- See 20-second-highest-per-department.md for the step-by-step version.
WITH ranked AS (
    SELECT
        department_id,
        salary,
        DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dr
    FROM Employee
    WHERE department_id IS NOT NULL
),
second AS (
    SELECT DISTINCT department_id, salary
    FROM ranked
    WHERE dr = 2
)
SELECT
    d.department_name,
    s.salary AS second_highest_salary
FROM Department d
LEFT JOIN second s ON s.department_id = d.id
ORDER BY d.department_name;
