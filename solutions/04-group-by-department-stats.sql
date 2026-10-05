-- 04 - GROUP BY with several aggregates
--
-- JOIN: INNER JOIN, because the prompt only wants departments that HAVE employees
--   (empty departments and the department-less contractor are dropped).
-- GROUP BY d.department_name: every aggregate below is computed per department.
--   Rule: every SELECT column must be either in GROUP BY or inside an aggregate.
-- AVG on an INTEGER column returns NUMERIC with many decimals -> ROUND(..., 2).
--   (MySQL: ROUND(AVG(salary), 2) works the same way.)
SELECT
    d.department_name,
    COUNT(*)                AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MIN(e.salary)           AS min_salary,
    MAX(e.salary)           AS max_salary,
    SUM(e.salary)           AS total_salary
FROM Employee e
JOIN Department d
  ON e.department_id = d.id
GROUP BY d.department_name
ORDER BY d.department_name;
