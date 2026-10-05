-- 10 - Scalar subquery: employees paid more than the company average
--
-- (SELECT AVG(salary) FROM Employee) is a SCALAR subquery: it returns exactly one
-- value (one row, one column), so it can be used anywhere a single value can.
-- It is NOT correlated (doesn't reference the outer row) -> computed once.
--
-- Why not "WHERE salary > AVG(salary)"? Aggregates aren't allowed in WHERE:
-- WHERE is evaluated per row, before any aggregation happens.
SELECT
    name AS employee_name,
    salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee)
ORDER BY salary DESC, name;
