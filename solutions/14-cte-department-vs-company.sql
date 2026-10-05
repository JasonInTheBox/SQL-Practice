-- 14 - CTEs: departments whose average salary beats the company-wide average
--
-- CTE = a named, temporary result set that lives only for this one statement.
-- Splitting the problem into named steps makes it read top-to-bottom:
--
--   company   : ONE row, the overall average (all 24 employees, including the
--               department-less contractor -- "company-wide").
--   dept_avg  : one row per department (INNER JOIN, so only departments with
--               employees). GROUP BY is needed because AVG must be per department.
--
-- Final SELECT: CROSS JOIN attaches the single company row to every department row,
-- then WHERE compares the two averages. (WHERE is fine here: after the CTE, avg_salary
-- is just an ordinary column of dept_avg, not an aggregate in this query level.)
--
-- One-query alternative without CTEs (HAVING + scalar subquery):
--   SELECT d.department_name, ROUND(AVG(e.salary), 2) AS avg_salary
--   FROM Employee e JOIN Department d ON e.department_id = d.id
--   GROUP BY d.department_name
--   HAVING AVG(e.salary) > (SELECT AVG(salary) FROM Employee)
--   ORDER BY avg_salary DESC;
WITH company AS (
    SELECT AVG(salary) AS company_avg
    FROM Employee
),
dept_avg AS (
    SELECT d.department_name,
           AVG(e.salary) AS avg_salary
    FROM Employee e
    JOIN Department d ON e.department_id = d.id
    GROUP BY d.department_name
)
SELECT
    da.department_name,
    ROUND(da.avg_salary, 2) AS avg_salary
FROM dept_avg da
CROSS JOIN company c
WHERE da.avg_salary > c.company_avg
ORDER BY da.avg_salary DESC;
