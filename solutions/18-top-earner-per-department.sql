-- 18 - Top 1 per group (with ties): highest-paid employee(s) in each department
--
-- RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC)
--   PARTITION BY department_id: restart the ranking for every department, as if
--     each department were its own little table. Without it you'd rank the whole
--     company and only Alice would get rank 1.
--   ORDER BY salary DESC: highest salary gets rank 1 inside each department.
--   RANK (or DENSE_RANK) gives tied people the same rank 1 -> HR returns both
--   Frank and Victor. ROW_NUMBER would arbitrarily drop one of them.
--
-- The window result can't be filtered in the same SELECT's WHERE (WHERE runs
-- before window functions), so compute it in a CTE and filter outside.
--
-- JOIN Department (INNER): gives the name and drops the department-less contractor.
--
-- Alternative without window functions (correlated subquery):
--   WHERE e.salary = (SELECT MAX(salary) FROM Employee x WHERE x.department_id = e.department_id)
WITH ranked AS (
    SELECT
        e.*,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rnk
    FROM Employee e
)
SELECT
    d.department_name,
    r.name AS employee_name,
    r.salary
FROM ranked r
JOIN Department d ON d.id = r.department_id
WHERE r.rnk = 1
ORDER BY d.department_name, r.name;
